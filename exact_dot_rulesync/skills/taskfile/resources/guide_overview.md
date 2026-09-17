---
url: /docs/guide.md
description: Overview of Taskfile concepts, including running, variables, includes, dependencies, and more.
---

# Guide Overview

This document provides a high-level overview of key concepts and common patterns when working with Taskfiles. For detailed information on specific topics, refer to the other resource files.

## Running Taskfiles

Specific Taskfiles can be called by specifying the `--taskfile` flag. If you don't specify a Taskfile, Task will automatically look for a file with one of the supported file names in the current directory. If you want to search in a different directory, you can use the `--dir` flag.

### Supported file names

Task looks for files with the following names, in order of priority:

* `Taskfile.yml`
* `taskfile.yml`
* `Taskfile.yaml`
* `taskfile.yaml`
* `Taskfile.dist.yml`
* `taskfile.dist.yml`
* `Taskfile.dist.yaml`
* `taskfile.dist.yaml`

The `.dist` variants allow projects to have one committed file (`.dist`) while still allowing individual users to override the Taskfile by adding an additional `Taskfile.yml` (which would be in your `.gitignore`).

### Running a Taskfile from a subdirectory

If a Taskfile cannot be found in the current working directory, it will walk up the file tree until it finds one (similar to how `git` works). When running Task from a subdirectory like this, it will behave as if you ran it from the directory containing the Taskfile.

You can use this functionality along with the special `{{.USER_WORKING_DIR}}` variable to create some very useful reusable tasks.

### Running a global Taskfile

If you call Task with the `--global` (alias `-g`) flag, it will look for your home directory instead of your working directory. In short, Task will look for a Taskfile that matches `$HOME/{T,t}askfile.{yml,yaml}`. This is useful to have automation that you can run from anywhere in your system!

### Reading a Taskfile from stdin

Taskfile also supports reading from stdin. This is useful if you are generating Taskfiles dynamically and don't want write them to disk. To tell task to read from stdin, you must specify the `-t/--taskfile` flag with the special `-` value. You may then pipe into Task as you would any other program.

## Environment variables

You can use `env` to set custom environment variables for a specific task or globally for all tasks.

### .env files

You can also ask Task to include `.env` like files by using the `dotenv:` setting. When the same variable is defined in multiple dotenv files, the first file in the list takes precedence.

## Including other Taskfiles

If you want to share tasks between different projects (Taskfiles), you can use the `includes` keyword. The tasks described in the given Taskfiles will be available with the informed namespace.

### OS-specific Taskfiles

You can include OS-specific Taskfiles by using a templating function.

### Directory of included Taskfile

By default, included Taskfile's tasks are run in the current directory, even if the Taskfile is in another directory, but you can force its tasks to run in another directory by using the `dir` option within the include.

### Optional includes

Includes marked as optional will allow Task to continue execution as normal if the included file is missing.

### Internal includes

Includes marked as internal will set all the tasks of the included file to be internal as well. This is useful when including utility tasks that are not intended to be used directly by the user.

### Flatten includes

You can flatten the included Taskfile tasks into the main Taskfile by using the `flatten` option. It means that the included Taskfile tasks will be available without the namespace.

### Exclude tasks from being included

You can exclude tasks from being included by using the `excludes` option.

### Vars of included Taskfiles

You can also specify variables when including a Taskfile.

### Namespace aliases

When including a Taskfile, you can give the namespace a list of `aliases`.

## Internal tasks

Internal tasks are tasks that cannot be called directly by the user. They will not appear in the output when running `task --list|--list-all`. Other tasks may call internal tasks in the usual way.

## Task directory

By default, tasks will be executed in the directory where the Taskfile is located. But you can easily make the task run in another folder, informing `dir`.

## Task dependencies

You may have tasks that depend on others. Just pointing them on `deps` will make them run automatically before running the parent task. Dependencies run in parallel.

### Fail-fast dependencies

If you want Task to stop executing further dependencies as soon as one fails, you can set `failfast: true` on your `.taskrc.yml` or for a specific task.

## Platform specific tasks and commands

You can restrict the running of tasks to explicit platforms using the `platforms:` key.

## Calling another task

When a task has many dependencies, they are executed concurrently. However, in some situations, you may need to call other tasks serially. Use `task: task-name` within `cmds`.

## Prevent unnecessary work

### By fingerprinting locally generated files and their sources

If a task generates something, you can inform Task the source and generated files (`sources` and `generates` keywords), so Task will prevent running them if not necessary.

### Using programmatic checks to indicate a task is up to date

Alternatively, you can inform a sequence of tests as `status`. If no error is returned (exit status 0), the task is considered up-to-date.

### Using programmatic checks to cancel the execution of a task and its dependencies

In addition to `status` checks, `preconditions` checks are the logical inverse of `status` checks. If you need a certain set of conditions to be *true* you can use the `preconditions` stanza.

### Conditional execution with `if`

The `if` attribute allows you to conditionally skip tasks or commands based on a shell command's exit code.

### Limiting when tasks run

You can control when a task is executed using `run` (values: `always`, `once`, `when_changed`).

### Ensuring required variables are set

Use `requires` to check that certain variables are set before running a task.

### Ensuring required variables have allowed values

You can also use `requires` to ensure that a variable is set to one of a predefined set of valid values.

### Prompting for missing variables interactively

If you want Task to prompt users for missing required variables instead of failing, you can enable interactive mode.

## Variables

Task allows you to set variables using the `vars` keyword. Variables can be `string`, `bool`, `int`, `float`, `array`, or `map`.

### Dynamic variables

Use `sh:` prop in a variable to assign the output of a command to a variable.

### Referencing other variables

You can reference other variables using templating or by `ref` keyword to maintain their type.

### Parsing JSON/YAML into map variables

Use `fromJson` or `fromYaml` templating functions to parse JSON/YAML strings into map variables.

## Looping over values

Task allows you to loop over certain values and execute a command for each.

### Looping over a static list

The simplest kind of loop is an explicit one.

### Looping over a matrix

Loop over all permutations of multiple lists using the `matrix` property.

### Looping over your task's sources or generated files

You are also able to loop over the `sources` of your task or the files it `generates`.

### Looping over variables

To loop over the contents of a variable, use the `var` key.

### Renaming variables

You can rename the iterator variable using the `as` property.

### Looping over tasks

You can use the `for` property alongside the `task` keyword to run tasks multiple times.

### Looping over dependencies

All looping techniques can be applied to the `deps` property, combining loops with concurrency.

## Forwarding CLI arguments to commands

If `--` is given in the CLI, all following parameters are added to a special `.CLI_ARGS` variable.

## Wildcard arguments

Use a wildcard (`*`) in your task's name to parse arguments. Matching arguments will be captured and stored in the `.MATCH` variable.

## Doing task cleanup with `defer`

With the `defer` keyword, it's possible to schedule cleanup to be run once the task finishes, even if the task fails.

## Best Practices

### Echo Commands for Task Status

Echo commands that output status messages (e.g., "Validating...", "Done") should use the `silent: true` option and should be separate commands from the actual task logic.

**Rationale**:
- `silent: true` suppresses the command itself from being displayed, showing only the echo output
- Separating echo commands makes the task structure clearer and easier to read
- This pattern helps provide clean, focused output without displaying shell commands

**Example**:
```yaml
tasks:
  my-task:
    cmds:
      - cmd: echo "Starting validation..."
        silent: true
      - some-command
      - cmd: echo "Validation complete"
        silent: true
```

**Without `silent: true`**, the output would show:
```
task: [my-task] echo "Starting validation..."
Starting validation...
```

**With `silent: true`**, the output is cleaner:
```
Starting validation...
```

The separator characters (e.g., `===`) are optional but helpful for visual clarity. Echo any informational message about what the task is doing.

### For-Loops with Internal Tasks

For tasks that iterate over multiple items (files, directories, etc.), use Taskfile's `for` loop with separate internal tasks for single-item logic, rather than embedding loops in shell scripts.

**Pattern**:
```yaml
public-task:
  desc: Process multiple items
  cmds:
    - cmd: echo "=== Processing items ==="
      silent: true
    - for: { var: item, sh: "find . -name '*.txt'" }
      task: _internal:process-single
    - cmd: echo "=== Complete ==="
      silent: true

_internal:process-single:
  internal: true
  requires:
    vars: [item]
  cmds:
    - |
      # Logic to process a single item
      echo "Processing {{.item}}"
```

**Benefits**:
- Clear separation of concerns: Taskfile handles iteration, internal task handles logic
- Easier to read and understand intent
- Reusable internal tasks across multiple public tasks
- Simpler to test single-item logic

**When to use**:
- Linting multiple files/directories
- Running the same validation on several items
- Any scenario requiring iteration with shared logic
