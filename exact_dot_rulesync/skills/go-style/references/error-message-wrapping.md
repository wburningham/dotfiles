---
metadata:
  ref: https://preslav.me/2023/04/14/golang-error-handling-is-a-form-of-storytelling/

# Go Error Message Wrapping

When handling errors in Go, add meaningful context that describes what the code was attempting when the error occurred. This creates a "story" that makes debugging straightforward.

## Core Patterns

### Standard library: `fmt.Errorf` with `%w`

Use `fmt.Errorf` with `%w` to wrap errors:

```go
res, err := getResult(id)
if err != nil {
    return nil, fmt.Errorf("obtaining result for id %s: %w", id, err)
}
```

The `%w` verb wraps the original error, preserving the ability to use `errors.Is()` and `errors.As()` for error inspection.

### Using `github.com/pkg/errors`

Many codebases use the `github.com/pkg/errors` package, which provides `Wrap` and `Wrapf` functions:

```go
import "github.com/pkg/errors"

res, err := getResult(id)
if err != nil {
    return nil, errors.Wrapf(err, "obtaining result for id %s", id)
}
```

- `errors.Wrap(err, "message")` — wraps with a static message
- `errors.Wrapf(err, "format %s", arg)` — wraps with a formatted message

Both approaches preserve the error chain for inspection with `errors.Is()` and `errors.As()`. The same message style rules apply regardless of which wrapping mechanism you use.

## Message Style Rules

### DO: Describe the action in progress

Write messages as gerund phrases (present participle) describing what the code was doing:

```go
return fmt.Errorf("polling for next job: %w", err)
return fmt.Errorf("fetching job owner for job %s: %w", jobID, err)
return fmt.Errorf("starting job %s: %w", jobID, err)
```

### DON'T: Use failure words or redundant phrases

The fact that it's an error already implies failure. Redundant phrasing creates noise and produces ugly chains like `error: failed to X: could not Y: unable to Z`.

**Failure verbs and phrases to avoid:**

| Avoid | Why |
|-------|-----|
| `failed to X` | Redundant — errors imply failure |
| `could not X` | Redundant |
| `couldn't X` | Redundant |
| `cannot X` | Redundant |
| `can't X` | Redundant |
| `unable to X` | Redundant |
| `error X` | Redundant — it's already an error |
| `error while Xing` | Redundant |
| `error occurred while Xing` | Redundant and verbose |
| `there was an error Xing` | Redundant and verbose |
| `X failed` | Redundant |
| `X error` | Redundant |
| `problem Xing` | Vague and redundant |
| `issue Xing` | Vague and redundant |
| `trouble Xing` | Vague and redundant |
| `exception while Xing` | Wrong language — Go has errors, not exceptions |

**Other phrases to avoid:**

| Avoid | Why |
|-------|-----|
| `invalid X` | Too vague — say what's wrong with it |
| `bad X` | Too vague |
| `wrong X` | Too vague |
| `unexpected X` | Can be vague — be specific about what was expected |

```go
// BAD — redundant failure words
return fmt.Errorf("failed to connect to database: %w", err)
return fmt.Errorf("could not fetch user: %w", err)
return errors.Wrap(err, "error while parsing config")
return errors.Wrapf(err, "unable to read file %s", path)
return fmt.Errorf("there was an error sending email: %w", err)
return errors.Wrap(err, "problem creating session")

// GOOD — action in progress
return fmt.Errorf("connecting to database: %w", err)
return fmt.Errorf("fetching user: %w", err)
return errors.Wrap(err, "parsing config")
return errors.Wrapf(err, "reading file %s", path)
return fmt.Errorf("sending email: %w", err)
return errors.Wrap(err, "creating session")
```

```go
// BAD — vague descriptors
return fmt.Errorf("invalid user ID: %w", err)
return fmt.Errorf("bad input: %w", err)

// GOOD — specific context
return fmt.Errorf("parsing user ID %q: %w", rawID, err)
return fmt.Errorf("validating request body: %w", err)
```

### DON'T: Just return the error

Never simply pass through an error without context:

```go
// BAD - provides no context
if err != nil {
    return err
}

// GOOD - tells the story
if err != nil {
    return fmt.Errorf("loading configuration: %w", err)
}

// Also GOOD - using pkg/errors
if err != nil {
    return errors.Wrap(err, "loading configuration")
}
```

## Why This Matters

Error messages chain together as they bubble up the call stack. Well-crafted messages create a readable narrative:

**Good chain:**
```
tracking parcel location: fetching order status: connecting to the DB
```

**Bad chain:**
```
error while tracking location: error while fetch order status: DB connection failed
```

The good chain reads naturally and immediately tells you:
1. What the user was trying to do (track parcel)
2. What operation was in progress (fetching order status)
3. What specifically failed (DB connection)

## Quick Reference

| Instead of | Write |
|------------|-------|
| `failed to X` | `Xing` |
| `could not X` / `couldn't X` | `Xing` |
| `cannot X` / `can't X` | `Xing` |
| `unable to X` | `Xing` |
| `error Xing` / `error while Xing` | `Xing` |
| `X failed` / `X error` | `Xing` |
| `problem Xing` / `trouble Xing` | `Xing` |
| `invalid X` / `bad X` | describe the validation: `validating X` |
| `return err` | `return fmt.Errorf("Xing: %w", err)` or `return errors.Wrap(err, "Xing")` |
