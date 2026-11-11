# Written by scripts/formula.sh from the SHA256SUMS of Lonca v0.2.3.
# Do not edit by hand: update.yml writes it again for every release.
class Lonca < Formula
  desc "Agent-native, Git-compatible version control"
  homepage "https://selcukgural.github.io/lonca/"
  version "0.2.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.3/lonca-aarch64-apple-darwin.tar.gz"
      sha256 "06df197ff4b2e5a799c242389c1db09e03e5bdb5f2a3968b7396542ddfe6d320"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.3/lonca-x86_64-apple-darwin.tar.gz"
      sha256 "d7eada1ad1ec70938ba03fe44867313e453d5c7889bf68a56f9dbe2db4d68442"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.3/lonca-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6609f93d01a1aa3869b3f2358d4674107c94d724ad818893b43b05c7522b7db7"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.3/lonca-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1ebea80893af916a73410b1991b54fab74d6f76eac4cac4f818fb0cfaf27e010"
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
