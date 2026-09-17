---
name: taskfile
description: >-
  This skill should be used when working with Taskfiles (go-task), including
  running the `task` CLI, creating, updating, or validating Taskfile
  configuration ((Tt)askfile(\.dist){0,1}\.yaml).
targets:
  - '*'
---
# Taskfile Skill

This skill provides comprehensive guidance and reference documentation for working with `go-task` Taskfiles. Taskfiles automate common development tasks using a simple, YAML-based syntax.

## When to Use This Skill

This skill should be used when:
*   Running the `task` command (e.g., to learn CLI usage options).
*   Creating, updating, or validating a Taskfile configuration file (e.g., "write a taskfile", "write a task", "use the go-task runner").
*   You need to understand Taskfile syntax, features, or best practices.

## Agent Usage Policy

When interacting with `task` commands, this agent will **NEVER** use the `-y` or `--yes` flags without explicit confirmation from the user. This ensures that all potentially destructive or affirmative `task` operations require direct user approval.

## Variable Authoring

Prefer pure Taskfile templating over `sh:` vars when the logic is only conditionals and string assembly.

Use `sh:` only when a subprocess is required (e.g. `git`, `docker`, reading files). Do not wrap template `if`/`else` branches in shell just to `echo` a result.

Match surrounding style when practical, but remove unnecessary shell processing first.

## Core Concepts and References

Below are the key areas of Taskfile functionality, each with a dedicated reference document for in-depth information and examples.

### Guide Overview

For a high-level introduction to Taskfile concepts, including how to run Taskfiles, manage environment variables, include other Taskfiles, handle dependencies, and prevent unnecessary work.
- **`resources/guide_overview.md`**: Overview of Taskfile concepts and common usage patterns.

### CLI Reference

For detailed information on the `task` command-line interface, including available options, flags, and exit codes.
- **`resources/cli_reference.md`**: Complete reference for Task CLI commands, flags, and exit codes.

### Schema Reference

For a comprehensive breakdown of the Taskfile YAML schema, including all available properties and their types.
- **`resources/schema_reference.md`**: A reference for the Taskfile schema version 3.

### Templating Reference

For a detailed guide to Task's templating system, including Go `text/template` usage, special variables, and available functions (many from `slim-sprig`).
- **`resources/templating_reference.md`**: Comprehensive guide to Task's templating system.

### Authoring Conventions

For opinionated best practices on writing tasks — when to prefer Go templates over shell logic, path construction with `list`/`join`, `dir:` pitfalls, `silent` strategy, `cmd` formatting, HTTP client detection, and naming conventions.
- **`resources/authoring_conventions.md`**: Practical patterns and pitfalls for writing well-structured Taskfiles.

## External Libraries Documentation

The templating system relies heavily on functions from external libraries.

### Slim-Sprig Functions

The majority of templating functions are provided by the `slim-sprig` library. Refer to this document for a full list and usage examples.
- **`resources/sprig_functions_reference.md`**: Comprehensive reference for all available Slim-Sprig functions.
