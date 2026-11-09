# Written by scripts/formula.sh from the SHA256SUMS of Lonca v0.2.2.
# Do not edit by hand: update.yml writes it again for every release.
class Lonca < Formula
  desc "Agent-native, Git-compatible version control"
  homepage "https://selcukgural.github.io/lonca/"
  version "0.2.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.2/lonca-aarch64-apple-darwin.tar.gz"
      sha256 "ff0cae4e43e183cbf457609dc9d1258725335bd6679f7aa6ce4ddea4e4d34e50"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.2/lonca-x86_64-apple-darwin.tar.gz"
      sha256 "c23303c559e881d7fb4186e53b2eef8e3b902c93eb7d4a624e85eab9c5b7b116"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.2/lonca-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e4b083fa8afeb30e1bfa3cce5ac5cf18e8b9e4758f4d1cc99c628cae062535ed"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.2/lonca-x86_64-unknown-linux-musl.tar.gz"
      sha256 "dcd45be2e269baa679774c30853055c59f4ce6c0ede1b5cfa794e07bf33abc3a"
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
