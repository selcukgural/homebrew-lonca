# Homebrew tap for Lonca

```sh
brew install selcukgural/lonca/lonca
```

Installs `lonca`, `lonca-audit` and, on macOS, `lonca-se` (the Secure Enclave
helper) from the [Lonca releases](https://github.com/selcukgural/lonca/releases):
macOS arm64 and x86_64, Linux x86_64 and arm64.

`Formula/lonca.rb` is written by `.github/workflows/update.yml` for the latest
published release, every day and on demand. It checks every archive against the
release's `SHA256SUMS` and its build provenance attestation (signed by Lonca's
`release.yml` on the release tag), and installs and tests the formula on macOS
and Linux before committing it. Do not edit the formula by hand.

Homebrew puts Lonca where your account can write: cooperative mode. For
hardened mode, see the formula's caveats (`brew info lonca`) and the
[README](https://github.com/selcukgural/lonca#observation-levels).

Lonca: https://selcukgural.github.io/lonca/
