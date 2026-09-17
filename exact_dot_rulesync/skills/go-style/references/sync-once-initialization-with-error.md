# sync.Once Initialization That Can Fail

`sync.Once` is the canonical Go primitive for "run this exactly once across goroutines." Its signature is `func (*Once) Do(f func())`, which means `f` cannot return an error. That makes it awkward for lazy initialization that can fail, like compiling a schema, opening a file, or building a cache.

This document describes the `errorOnce` helper type that pairs `sync.Once` with cached-error semantics, and when to use it instead of alternatives.

## The naive pattern is broken

A common first instinct is to capture the error in an outer-scope variable:

```go
var err error
c.initOnce.Do(func() {
    err = c.init()
})
if err != nil {
    return err
}
```

This looks fine but loses errors on every call after the first. `sync.Once.Do` only runs `f` once. The first caller sets `err`; every subsequent caller sees `err == nil` because the closure never executes again. Downstream code then operates on a half-initialized struct, often crashing in a less obvious place.

The fix is to remember the error somewhere durable. The simplest version is a field on the struct holding the `sync.Once`:

```go
type T struct {
    initOnce sync.Once
    initErr  error
    ...
}

func (t *T) ensureInit() error {
    t.initOnce.Do(func() { t.initErr = t.doInit() })
    return t.initErr
}
```

This works, but it spreads two related fields across every type that needs lazy fallible init, and it forces callers to either know the two-step dance or write a wrapper method on every type.

## The `errorOnce` helper

Create a small package-local type that bundles the once-guard and the cached error:

```go
// once.go

package mypkg

import "sync"

// errorOnce runs an initializer at most once and remembers any error it
// returned. Subsequent calls skip the initializer and return the cached error.
// The zero value is ready for use; safe for concurrent calls.
type errorOnce struct {
    once sync.Once
    err  error
}

// Do runs f the first time it is called and returns the (possibly cached)
// error from that run. f is never called again.
func (o *errorOnce) Do(f func() error) error {
    o.once.Do(func() { o.err = f() })
    return o.err
}
```

Hosts of lazy state then expose a single field and a single method:

```go
type T struct {
    initOnce errorOnce
    ...
}

func (t *T) init() error {
    return t.initOnce.Do(func() error {
        // ... do the work, return any error directly
        return nil
    })
}

func (t *T) PublicMethod(...) error {
    if err := t.init(); err != nil {
        return err
    }
    // ... use the initialized state
}
```

The init body returns errors directly with `return fmt.Errorf(...)` instead of writing to a `initErr` field, which reads more naturally and removes the two-statement preamble at every call site.

## When to use it

Reach for `errorOnce` when **all** of these hold:

- Initialization is **lazy** (you can't or don't want to do it in a constructor).
- Initialization can **fail**, and callers need to see the failure.
- Initialization has multiple potential entry points (otherwise just inline the work).
- The initialized state is **immutable** after success (no retry needed).

A typical fit is a type that compiles or builds something expensive (a CUE schema, a regex set, a parsed config, a connection pool) on first use, where the compilation can fail because of bad inputs that you only know at runtime.

## When not to use it

- **Prefer a constructor.** If you control all the call sites, `NewT(...) (*T, error)` is cleaner. Errors flow synchronously to the place that configured the type. No `sync.Once`, no mutex, no cached error. Use lazy init only when forced (zero-value-usable struct, plugin lifecycles, etc.).
- **No error possible.** If `init` can't fail, plain `sync.Once` is fine.
- **You want retry on failure.** `errorOnce` caches the error forever. If init failure is transient (a network call, a flaky filesystem), use a `sync.Mutex` plus a "did it succeed" flag so the next caller can try again.
- **You need parameters per call.** `sync.Once` is for unconditional one-time work. If different callers want different init, you need a `sync.Map` or a `singleflight.Group`, not this.

## Where to put `once.go`

Keep it package-local. It's a 15-line internal helper; sharing it across packages adds a dependency for no benefit. If multiple packages independently want this pattern, each can define its own copy. Resist the urge to publish a generic `errorOnce` library type until you have at least three real users.
