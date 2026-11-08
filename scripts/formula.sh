#!/bin/sh
# Writes Formula/lonca.rb for a Lonca release to stdout.
#
#   scripts/formula.sh VERSION SHA256SUMS
#
# VERSION is the release's version without the `v` (0.2.0); SHA256SUMS is
# that release's file, already checked against the archives and their
# attestations (update.yml does both). Fails when an archive is missing
# from it or a checksum is not 64 hex digits.
set -eu

[ "$#" -eq 2 ] || { echo "usage: $0 VERSION SHA256SUMS" >&2; exit 2; }
version=$1
sums=$2

case "$version" in
    *[!0-9A-Za-z.-]* | "") echo "not a version: $version" >&2; exit 1 ;;
esac

sum() {
    s=$(grep "  lonca-$1.tar.gz\$" "$sums" | cut -d ' ' -f 1)
    case "$s" in
        *[!0-9a-f]* | "") echo "SHA256SUMS has no checksum for lonca-$1.tar.gz" >&2; exit 1 ;;
    esac
    [ "${#s}" -eq 64 ] || { echo "not a SHA-256: $s" >&2; exit 1; }
    printf '%s' "$s"
}

mac_arm=$(sum aarch64-apple-darwin)
mac_intel=$(sum x86_64-apple-darwin)
linux_arm=$(sum aarch64-unknown-linux-musl)
linux_intel=$(sum x86_64-unknown-linux-musl)
url="https://github.com/selcukgural/lonca/releases/download/v$version"

cat <<EOF
# Written by scripts/formula.sh from the SHA256SUMS of Lonca v$version.
# Do not edit by hand: update.yml writes it again for every release.
class Lonca < Formula
  desc "Agent-native, Git-compatible version control"
  homepage "https://selcukgural.github.io/lonca/"
  version "$version"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "$url/lonca-aarch64-apple-darwin.tar.gz"
      sha256 "$mac_arm"
    end
    on_intel do
      url "$url/lonca-x86_64-apple-darwin.tar.gz"
      sha256 "$mac_intel"
    end
  end

  on_linux do
    on_arm do
      url "$url/lonca-aarch64-unknown-linux-musl.tar.gz"
      sha256 "$linux_arm"
    end
    on_intel do
      url "$url/lonca-x86_64-unknown-linux-musl.tar.gz"
      sha256 "$linux_intel"
    end
  end

  def install
    bin.install "lonca", "lonca-audit"
    # The Secure Enclave helper; lonca looks for it next to itself.
    bin.install "lonca-se" if OS.mac?
    pkgshare.install Dir["*-hardened.sh"]
  end

  def caveats
    <<~TEXT
      This is cooperative mode: Homebrew's prefix is writable by your account.
      For hardened mode, run the installer from the release archive as root:
        sudo #{opt_pkgshare}/install-hardened.sh --bin #{opt_bin}
      (it copies the binaries root-owned; see the README, "Observation levels").
    TEXT
  end

  test do
    assert_equal "lonca #{version}", shell_output("#{bin}/lonca --version").strip
    assert_path_exists bin/"lonca-audit"
  end
end
EOF
