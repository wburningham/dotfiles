---
url: https://sprig.taskfile.dev/
description: Useful template functions for Go templates.
---

# Sprig Functions Reference

This document compiles the documentation for all functions available through the Slim-Sprig library, used in Taskfile templating. These functions enhance Go's `text/template` capabilities with a wide range of utilities for strings, math, dates, encoding, lists, dictionaries, type conversion, paths, flow control, and more.

---

## String Functions

## `trim`

Remove leading and trailing whitespace.

```go-template
{{ "  hello world  " | trim }}
```

Output: `hello world`

## `trimAll "chars" "string"`

Remove leading and trailing characters.

```go-template
{{ "**hello world**" | trimAll "*" }}
```

Output: `hello world`

## `trimPrefix "prefix" "string"`

Remove prefix.

```go-template
{{ "hello world" | trimPrefix "hello " }}
```

Output: `world`

## `trimSuffix "suffix" "string"`

Remove suffix.

```go-template
{{ "hello world" | trimSuffix " world" }}
```

Output: `hello`

## `nospace`

Remove all whitespace.

```go-template
{{ "  h e l l o   w o r l d  " | nospace }}
```

Output: `helloworld`

## `trunc "length" "string"`

Truncate a string.

```go-template
{{ "hello world" | trunc 5 }}
```

Output: `hello`

## `substr "start" "end" "string"`

Extract a substring.

```go-template
{{ "hello world" | substr 0 5 }}
```

Output: `hello`

## `repeat "count" "string"`

Repeat a string.

```go-template
{{ "abc" | repeat 3 }}
```

Output: `abcabcabc`

## `replace "old" "new" "string"`

Replace occurrences of a substring.

```go-template
{{ "hello world" | replace "o" "X" }}
```

Output: `hellX wXrld`

## `replaceAll "old" "new" "string"`

Replace all occurrences of a substring.

```go-template
{{ "hello world" | replaceAll "o" "X" }}
```

Output: `hellX wXrld`

## `split "delimiter" "string"`

Split a string by delimiter. Returns a string slice.

```go-template
{{ "a,b,c" | split "," }}
```

Output: `[a b c]`

## `splitN "delimiter" "string" "count"`

Split a string by delimiter, returning a maximum of `count` parts.

```go-template
{{ "a,b,c,d" | splitN "," 2 }}
```

Output: `[a b,c,d]`

## `hasPrefix "prefix" "string"`

Check if string has prefix.

```go-template
{{ "hello world" | hasPrefix "hello" }}
```

Output: `true`

## `hasSuffix "suffix" "string"`

Check if string has suffix.

```go-template
{{ "hello world" | hasSuffix "world" }}
```

Output: `true`

## `contains "substring" "string"`

Check if string contains substring.

```go-template
{{ "hello world" | contains "world" }}
```

Output: `true`

## `upper`

Convert to uppercase.

```go-template
{{ "hello world" | upper }}
```

Output: `HELLO WORLD`

## `lower`

Convert to lowercase.

```go-template
{{ "HELLO WORLD" | lower }}
```

Output: `hello world`

## `title`

Convert to title case.

```go-template
{{ "hello world" | title }}
```

Output: `Hello World`

## `untitle`

Convert to untitle case.

```go-template
{{ "Hello World" | untitle }}
```

Output: `hello World`

## `snakecase`

Convert to snake_case.

```go-template
{{ "helloWorld" | snakecase }}
```

Output: `hello_world`

## `camelcase`

Convert to camelCase.

```go-template
{{ "hello_world" | camelcase }}
```

Output: `helloWorld`

## `kebabcase`

Convert to kebab-case.

```go-template
{{ "hello_world" | kebabcase }}
```

Output: `hello-world`

## `pascalcase`

Convert to PascalCase.

```go-template
{{ "hello_world" | pascalcase }}
```

Output: `HelloWorld`

## `ansiColor "color" "string"`

Apply ANSI color to a string.

```go-template
{{ "hello" | ansiColor "red" }}
```

Output: `\x1b[31mhello\x1b[0m` (red color code)

## `quote`

Quote a string.

```go-template
{{ "hello world" | quote }}
```

Output: `"hello world"`

## `squote`

Single quote a string.

```go-template
{{ "hello world" | squote }}
```

Output: `'hello world'`

## `indent "count" "string"`

Indent a multiline string.

```go-template
{{ "line1\nline2" | indent 2 }}
```

Output: `  line1\n  line2`

## `nindent "count" "string"`

Indent a multiline string with a leading newline.

```go-template
{{ "line1\nline2" | nindent 2 }}
```

Output: `\n  line1\n  line2`

## `wrap "width" "string"`

Wrap a string to a given width.

```go-template
{{ "Lorem ipsum dolor sit amet" | wrap 10 }}
```

Output: `Lorem ipsum\ndolor sit\namet`

## `randAlpha "count"`

Generate random alphabetic string.

```go-template
{{ randAlpha 5 }}
```

Output: `fghij` (random)

## `randAlphaNum "count"`

Generate random alphanumeric string.

```go-template
{{ randAlphaNum 5 }}
```

Output: `fghij12345` (random)

## `randAscii "count"`

Generate random ASCII string.

```go-template
{{ randAscii 5 }}
```

Output: `fghij!@#$(` (random)

## `randNumeric "count"`

Generate random numeric string.

```go-template
{{ randNumeric 5 }}
```

Output: `12345` (random)

## `regexFind "regex" "string"`

Find first match of regex.

```go-template
{{ regexFind "[0-9]+" "abc123def456" }}
```

Output: `123`

## `regexFindAll "regex" "string" "n"`

Find all matches of regex.

```go-template
{{ regexFindAll "[0-9]+" "abc123def456" -1 }}
```

Output: `[123 456]`

## `regexReplaceAll "regex" "string" "replace"`

Replace all matches of regex.

```go-template
{{ regexReplaceAll "[0-9]+" "abc123def456" "X" }}
```

Output: `abcXdefX`

## `regexMatch "regex" "string"`

Check if string matches regex.

```go-template
{{ regexMatch "[0-9]+" "abc123def456" }}
```

Output: `true`

## `abbrev "length" "string"`

Abbreviate a string.

```go-template
{{ "hello world" | abbrev 5 }}
```

Output: `he...`

## `abbrevboth "length" "offset" "string"`

Abbreviate a string on both sides.

```go-template
{{ "hello world" | abbrevboth 5 3 }}
```

Output: `...lo...`

## `initials "string"`

Get initials from a string.

```go-template
{{ "hello world" | initials }}
```

Output: `HW`

## `shuffle "string"`

Shuffle a string.

```go-template
{{ "hello" | shuffle }}
```

Output: `olleh` (random)

## `randomPick "values..."`

Pick a random value.

```go-template
{{ randomPick "foo" "bar" "baz" }}
```

Output: `bar` (random)

---

## String List Functions

These functions operate on slices of strings.

## `join "separator" "list"`

Join a list of strings with a separator.

```go-template
{{ list "a" "b" "c" | join "," }}
```

Output: `a,b,c`

## `splitList "delimiter" "string"`

Split a string into a list by delimiter.

```go-template
{{ "a,b,c" | splitList "," }}
```

Output: `[a b c]`

## `sortAlpha "list"`

Sort a list of strings alphabetically.

```go-template
{{ list "c" "a" "b" | sortAlpha }}
```

Output: `[a b c]`

---

## Integer Math Functions

These functions perform mathematical operations on integers.

## `add "num1" "num2" ...`

Add numbers.

```go-template
{{ add 1 2 3 }}
```

Output: `6`

## `sub "num1" "num2" ...`

Subtract numbers.

```go-template
{{ sub 5 2 }}
```

Output: `3`

## `mul "num1" "num2" ...`

Multiply numbers.

```go-template
{{ mul 2 3 }}
```

Output: `6`

## `div "num1" "num2"`

Divide numbers.

```go-template
{{ div 6 2 }}
```

Output: `3`

## `mod "num1" "num2"`

Modulo operation.

```go-template
{{ mod 7 3 }}
```

Output: `1`

## `max "num1" "num2" ...`

Return the maximum number.

```go-template
{{ max 1 5 3 }}
```

Output: `5`

## `min "num1" "num2" ...`

Return the minimum number.

```go-template
{{ min 1 5 3 }}
```

Output: `1`

## `randInt "min" "max"`

Generate a random integer within a range [min, max).

```go-template
{{ randInt 1 10 }}
```

Output: `7` (random)

## `randIntN "n"`

Generate a random integer within a range [0, n).

```go-template
{{ randIntN 10 }}
```

Output: `5` (random)

---

## Integer Slice Functions

These functions generate sequences of integers.

## `until "count"`

Generate a list of integers from 0 up to (but not including) count.

```go-template
{{ until 3 }}
```

Output: `[0 1 2]`

## `untilStep "start" "end" "step"`

Generate a list of integers from start up to (but not including) end, with a given step.

```go-template
{{ untilStep 1 7 2 }}
```

Output: `[1 3 5]`

---

## Date Functions

These functions work with dates and times.

## `now`

Return the current UTC time.

```go-template
{{ now }}
```

Output: `2023-10-27 10:00:00.123456789 +0000 UTC` (example)

## `date "format" "time"`

Format a time object. Use Go's reference time layout.

```go-template
{{ now | date "2006-01-02" }}
```

Output: `2023-10-27`

## `dateInZone "format" "time" "zone"`

Format a time object in a specific timezone.

```go-template
{{ now | dateInZone "2006-01-02 15:04" "America/New_York" }}
```

Output: `2023-10-27 06:00` (example)

## `toDuration "string"`

Convert a string to a duration.

```go-template
{{ "1h30m" | toDuration }}
```

Output: `1h30m0s`

## `ago "time"`

Return time passed since.

```go-template
{{ now | ago }}
```

Output: `0s` (example)

## `dateModify "duration" "time"`

Modify a time by a duration string.

```go-template
{{ now | dateModify "1h" | date "15:04" }}
```

Output: `11:00` (example)

## `unixEpoch "time"`

Return Unix epoch timestamp.

```go-template
{{ now | unixEpoch }}
```

Output: `1698393600` (example)

## `toTime "string"`

Parse a string into a time object.

```go-template
{{ "2023-10-27T10:00:00Z" | toTime | date "2006-01-02" }}
```

Output: `2023-10-27`

## `toDate "format" "string"`

Parse a string into a time object with a specific format.

```go-template
{{ "2023-10-27" | toDate "2006-01-02" | date "Jan 2, 2006" }}
```

Output: `Oct 27, 2023`

## `humanDuration "duration"`

Format a duration into a human-readable string.

```go-template
{{ "1h30m" | toDuration | humanDuration }}
```

Output: `1 hour 30 minutes`

---

## Defaults Functions

These functions provide default values and handle empty variables.

## `default "defaultValue" "value"`

Return `value` if not empty, otherwise `defaultValue`.

```go-template
{{ "" | default "fallback" }}
```

Output: `fallback`

## `empty "value"`

Check if value is empty.

```go-template
{{ "" | empty }}
```

Output: `true`

## `coalesce "value1" "value2" ...`

Return the first non-empty value.

```go-template
{{ coalesce "" "fallback" "never seen" }}
```

Output: `fallback`

## `fromJson "jsonString"`

Parse a JSON string into a Go object (map/slice).

```go-template
{{ `{"a": 1}` | fromJson | get "a" }}
```

Output: `1`

## `toJson "object"`

Convert a Go object to a JSON string.

```go-template
{{ dict "a" 1 | toJson }}
```

Output: `{"a":1}`

## `toPrettyJson "object"`

Convert a Go object to a pretty-printed JSON string.

```go-template
{{ dict "a" 1 | toPrettyJson }}
```

Output:
```json
{
  "a": 1
}
```

## `toRawJson "object"`

Convert a Go object to a JSON string without escaping HTML.

## `ternary "trueVal" "falseVal" "condition"`

Ternary operator. Returns `trueVal` if `condition` is true, otherwise `falseVal`.

```go-template
{{ ternary "yes" "no" true }}
```

Output: `yes`

---

## Encoding Functions

These functions handle various encoding and decoding operations.

## `b64enc "string"`

Base64 encode a string.

```go-template
{{ "hello" | b64enc }}
```

Output: `aGVsbG8=`

## `b64dec "string"`

Base64 decode a string.

```go-template
{{ "aGVsbG8=" | b64dec }}
```

Output: `hello`

## `urlqueryenc "string"`

URL query encode a string.

```go-template
{{ "hello world" | urlqueryenc }}
```

Output: `hello+world`

## `urlquerydec "string"`

URL query decode a string.

```go-template
{{ "hello+world" | urlquerydec }}
```

Output: `hello world`

---

## Lists and List Functions

These functions operate on Go slices (lists).

## `list "item1" "item2" ...`

Create a new list.

```go-template
{{ list "a" "b" "c" }}
```

Output: `[a b c]`

## `first "count" "list"` or `first "list"`

Get the first `count` items from a list, or the first item.

```go-template
{{ list "a" "b" "c" | first 2 }}
```

Output: `[a b]`

## `last "count" "list"` or `last "list"`

Get the last `count` items from a list, or the last item.

```go-template
{{ list "a" "b" "c" | last 2 }}
```

Output: `[b c]`

## `rest "list"`

Get all but the first item from a list.

```go-template
{{ list "a" "b" "c" | rest }}
```

Output: `[b c]`

## `initial "list"`

Get all but the last item from a list.

```go-template
{{ list "a" "b" "c" | initial }}
```

Output: `[a b]`

## `append "list" "item1" "item2" ...`

Append items to a list.

```go-template
{{ list "a" "b" | append "c" }}
```

Output: `[a b c]`

## `prepend "list" "item1" "item2" ...`

Prepend items to a list.

```go-template
{{ list "a" "b" | prepend "c" }}
```

Output: `[c a b]`

## `reverse "list"`

Reverse a list.

```go-template
{{ list "a" "b" "c" | reverse }}
```

Output: `[c b a]`

## `uniq "list"`

Remove duplicate items from a list.

```go-template
{{ list "a" "b" "a" | uniq }}
```

Output: `[a b]`

## `without "list" "item1" "item2" ...`

Remove specific items from a list.

```go-template
{{ list "a" "b" "c" | without "b" }}
```

Output: `[a c]`

## `has "item" "list"`

Check if a list contains an item.

```go-template
{{ list "a" "b" "c" | has "b" }}
```

Output: `true`

## `intersect "list1" "list2"`

Return the intersection of two lists.

```go-template
{{ intersect (list "a" "b") (list "b" "c") }}
```

Output: `[b]`

## `union "list1" "list2"`

Return the union of two lists.

```go-template
{{ union (list "a" "b") (list "b" "c") }}
```

Output: `[a b c]`

## `slice "list" "start" "end"`

Extract a sub-slice from a list.

```go-template
{{ list "a" "b" "c" "d" | slice 1 3 }}
```

Output: `[b c]`

---

## Dictionaries and Dict Functions

These functions operate on Go maps (dictionaries).

## `dict "key1" "value1" "key2" "value2" ...`

Create a new dictionary.

```go-template
{{ dict "name" "John" "age" 30 }}
```

Output: `map[age:30 name:John]`

## `get "dict" "key"`

Get a value from a dictionary by key.

```go-template
{{ dict "a" 1 | get "a" }}
```

Output: `1`

## `set "key" "value" "dict"`

Set a value in a dictionary.

```go-template
{{ dict "a" 1 | set "b" 2 }}
```

Output: `map[a:1 b:2]`

## `unset "key" "dict"`

Unset a key from a dictionary.

```go-template
{{ dict "a" 1 "b" 2 | unset "b" }}
```

Output: `map[a:1]`

## `hasKey "dict" "key"`

Check if a dictionary has a key.

```go-template
{{ dict "a" 1 | hasKey "a" }}
```

Output: `true`

## `keys "dict"`

Get all keys from a dictionary.

```go-template
{{ dict "a" 1 "b" 2 | keys }}
```

Output: `[a b]` (order may vary)

## `values "dict"`

Get all values from a dictionary.

```go-template
{{ dict "a" 1 "b" 2 | values }}
```

Output: `[1 2]` (order may vary)

## `merge "dict1" "dict2" ...`

Merge multiple dictionaries. Later dictionaries override earlier ones.

```go-template
{{ merge (dict "a" 1) (dict "b" 2) }}
```

Output: `map[a:1 b:2]`

## `mergeOverwrite "dict1" "dict2" ...`

Merge multiple dictionaries, overwriting existing keys. Alias for `merge`.

## `pick "dict" "key1" "key2" ...`

Pick specific keys from a dictionary.

```go-template
{{ dict "a" 1 "b" 2 "c" 3 | pick "a" "c" }}
```

Output: `map[a:1 c:3]`

## `omit "dict" "key1" "key2" ...`

Omit specific keys from a dictionary.

```go-template
{{ dict "a" 1 "b" 2 "c" 3 | omit "a" "c" }}
```

Output: `map[b:2]`

## `dig "key1" "key2" ... "dict"`

Safely get a nested value from a dictionary.

```go-template
{{ dict "a" (dict "b" 1) | dig "a" "b" }}
```

Output: `1`

## `getOrNil "dict" "key"`

Get a value from a dictionary, returning nil if key not found.

---

## Type Conversion Functions

These functions convert values between different types.

## `atoi "string"`

Convert string to integer.

```go-template
{{ "123" | atoi }}
```

Output: `123`

## `int64 "value"`

Convert to int64.

```go-template
{{ 123 | int64 }}
```

Output: `123`

## `float64 "value"`

Convert to float64.

```go-template
{{ "3.14" | float64 }}
```

Output: `3.14`

## `toString "value"`

Convert to string.

```go-template
{{ 123 | toString }}
```

Output: `123`

## `toStrings "list"`

Convert a list of any type to a list of strings.

```go-template
{{ list 1 2 "c" | toStrings }}
```

Output: `[1 2 c]`

## `toBool "value"`

Convert to boolean.

```go-template
{{ "true" | toBool }}
```

Output: `true`

---

## Path and Filepath Functions

These functions manipulate file paths.

## `base "path"`

Get the last element of a path.

```go-template
{{ "/a/b/c.txt" | base }}
```

Output: `c.txt`

## `dir "path"`

Get the directory of a path.

```go-template
{{ "/a/b/c.txt" | dir }}
```

Output: `/a/b`

## `ext "path"`

Get the file extension of a path.

```go-template
{{ "/a/b/c.txt" | ext }}
```

Output: `.txt`

## `clean "path"`

Clean a path.

```go-template
{{ "/a/b/../c" | clean }}
```

Output: `/a/c`

## `isAbs "path"`

Check if a path is absolute.

```go-template
{{ "/a/b" | isAbs }}
```

Output: `true`

## `osBase "path"`

OS-specific base.

## `osDir "path"`

OS-specific dir.

## `osExt "path"`

OS-specific ext.

## `osClean "path"`

OS-specific clean.

## `osIsAbs "path"`

OS-specific isAbs.

## `joinPath "elem1" "elem2" ...`

Join path elements.

```go-template
{{ joinPath "/a" "b" "c" }}
```

Output: `/a/b/c`

## `splitPath "path"`

Split a path into directory and file.

```go-template
{{ "/a/b/c.txt" | splitPath }}
```

Output: `[/a/b c.txt]`

## `relPath "base" "target"`

Get the relative path from base to target.

```go-template
{{ relPath "/a/b" "/a/b/c" }}
```

Output: `c`

## `toSlash "path"`

Convert path separators to forward slashes.

## `fromSlash "path"`

Convert path separators from forward slashes to OS-specific.

---

## Flow Control Functions

These functions control template execution flow.

## `fail "message"`

Cause template execution to fail with a given message.

```go-template
{{ fail "Something went wrong!" }}
```

Output: Error "Something went wrong!"

---

## OS Functions

These functions provide access to OS-level information.

## `env "varName"`

Get an environment variable.

```go-template
{{ env "HOME" }}
```

Output: `/home/user` (example)

## `expandenv "string"`

Expand environment variables in a string.

```go-template
{{ "$HOME/foo" | expandenv }}
```

Output: `/home/user/foo` (example)

## `numCPU`

Return the number of CPU cores.

```go-template
{{ numCPU }}
```

Output: `8` (example)

## `os`

Return the operating system.

```go-template
{{ OS }}
```

Output: `linux` (example)

## `arch`

Return the architecture.

```go-template
{{ ARCH }}
```

Output: `amd64` (example)

---

## Reflection

These functions provide information about Go types.

## `typeOf "value"`

Return the Go type of a value.

```go-template
{{ 1 | typeOf }}
```

Output: `int`

## `kindIs "kind" "value"`

Check if value is of a certain kind.

```go-template
{{ 1 | kindIs "int" }}
```

Output: `true`

## `typeIs "type" "value"`

Check if value is of a certain type.

```go-template
{{ "hello" | typeIs "string" }}
```

Output: `true`

## `typeIsLike "type" "value"`

Check if value is type-compatible with a certain type.

---

## Cryptographic and Security Functions

These functions provide cryptographic utilities.

## `sha256sum "string"`

Calculate SHA256 checksum of a string.

```go-template
{{ "hello" | sha256sum }}
```

Output: `2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824`

## `htpasswd "user" "pass"`

Generate an htpasswd entry.

```go-template
{{ htpasswd "user" "password" }}
```

Output: `user:$2y$05$xxxxxxxxxxxxxxxxxxxxxxxxx.` (example)

---
