---
name: go-style
description: >-
  This skill should be used when the user asks to "review Go code", "write
  idiomatic Go", "handle errors in Go", "wrap Go errors", "initialize a Go
  application", or needs guidance on Go style, error handling patterns, or
  application initialization.
targets:
  - '*'
---
# Go style guide

This skill provides guidelines for writing and reviewing Go code. Use it when authoring new Go code or reviewing merge requests to ensure consistency and idiomatic patterns.

## Core principles

- **Clarity over cleverness** — Write code that's easy to read and understand
- **Errors are values** — Handle errors explicitly and add meaningful context
- **Package-level organization** — Group related functionality logically
- **Minimal interfaces** — Accept interfaces, return concrete types
- **Explicit over implicit** — Avoid magic; make behavior obvious

## Additional resources

Load these resources when working on specific areas:

- **Error handling and wrapping** — When writing or reviewing error handling code using `fmt.Errorf` with `%w` or `github.com/pkg/errors` Wrap/Wrapf, or when errors need meaningful context through the call stack.
  - [Error Message Wrapping](./references/error-message-wrapping.md)

- **Application initialization** — When writing or reviewing HTTP servers, CLI tools, or any application that reads configuration from environment variables at startup.
  - [Variable Initialization for Apps](./references/variable-initialization-for-apps.md)

- **Lazy initialization that can fail**: when writing or reviewing a type that builds expensive state on first use (compiled schemas, regex sets, parsed configs) where the build can fail and the failure must be visible to every caller. Covers why the naive `sync.Once` plus outer-scope `err` pattern loses errors on subsequent calls, and gives an `errorOnce` helper that pairs `sync.Once` with cached-error semantics.
  - [sync.Once Initialization With Error](./references/sync-once-initialization-with-error.md)
