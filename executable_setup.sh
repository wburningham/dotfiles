#!/bin/bash
set -euo pipefail

info() { echo -e "  \033[38;5;252m $*\033[0m"; }
success() { echo -e "  \033[32m\033[1m󰌶 $*\033[0m"; }
warn() { echo -e "  \033[38;5;137m󰀪 $*\033[0m"; }

# Fish setup
if ! grep -q fish /etc/shells; then
  info "Adding $(which fish) to /etc/shells - will ask sudo password"
  which fish | sudo tee -a /etc/shells
fi
if ! finger "$USER" | grep -q 'Shell: .*fish'; then
  info "Setting $(which fish) as the default shell - will ask user password"
  chsh -s "$(which fish)"
fi

success "All done!"
