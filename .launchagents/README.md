### Commands

To stop and immediately restart the loaded launch agent:

> launchctl kickstart -k gui/$(id -u)/com

### GitHub proxy token

`chezmoi.wesb.readonly-dev-proxy.yaml.tmpl` proxies `https://127.0.0.1:9443` to `api.github.com`. It injects a token that it reads from the login keychain. Use it from gh with `GH_HOST=127.0.0.1:9443`.

Create a fine-grained personal access token:

- **Resource owner:** your personal account. Choosing an org can require admin approval.
- **Expiration:** set a date. The proxy returns 401s after it expires.
- **Repository access:** "Public repositories". This grants read-only access to all public repos and allows no repository permissions.
- **Account permissions:** leave all at "No access".

That covers `gh search issues`, `prs`, `code`, `repos`, and `commits` across public GitHub.

To search your own private repos, switch to "Only select repositories" and grant these read-only permissions:

| Permission    | Needed for                                                    |
| ---           | ---                                                           |
| Metadata      | Any repository access (set automatically)                     |
| Contents      | Code and commit search                                        |
| Issues        | Issue search                                                  |
| Pull requests | PR search                                                     |
| Discussions   | GraphQL only, which the proxy blocks because it's always POST |

Store the token (prompts for the value):

> security add-generic-password -a readonly-eng-proxy -s GH_PROXY_TOKEN -w

The proxy reads the token at startup, so restart it after storing or rotating the token.

### Context7 proxy API key

`chezmoi.wesb.readonly-dev-proxy.yaml.tmpl` also proxies `http://127.0.0.1:9177` to `context7.com`. It forwards only the read endpoints the `ctx7` CLI calls and injects an API key from the login keychain. The `~/.local/bin/ctx7` wrapper points the CLI at it with `CONTEXT7_BASE_URL`, so agents never see the key.

Store the key (prompts for the `ctx7sk-...` value):

> security add-generic-password -a readonly-eng-proxy -s CONTEXT7_API_KEY -w

Restart the proxy after storing or rotating the key.

### Caddy certificate

Trust the caddy cert after the proxy has started once (since that’s when Caddy creates the CA):

> sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$HOME/Library/Application Support/Caddy/pki/authorities/local/root.crt"
