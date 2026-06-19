# Personal abbreviation overrides.
#
# This file is named with a `zz_` prefix so fish sources it after the other
# conf.d snippets (notably git.fish from the jhillyerd/plugin-git plugin),
# letting these definitions win over the plugin defaults.

# Override plugin-git's `glg` (default: git log --stat).
abbr -a -g glg git log --stat --abbrev-commit
