# Written by scripts/formula.sh from the SHA256SUMS of Lonca v0.2.1.
# Do not edit by hand: update.yml writes it again for every release.
class Lonca < Formula
  desc "Agent-native, Git-compatible version control"
  homepage "https://selcukgural.github.io/lonca/"
  version "0.2.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.1/lonca-aarch64-apple-darwin.tar.gz"
      sha256 "047340033be8817a759173c224b83e03cacf1c457f46f2f9cd6668069816828c"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.1/lonca-x86_64-apple-darwin.tar.gz"
      sha256 "1e26d26bba185acb53f49952d82b794a34973d713109fe7db1926b0efd8d4336"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.1/lonca-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0273dcae3713cc78a6ca67ca907e2cb07602a6fc9a5fdec34b983ee436383a5c"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.1/lonca-x86_64-unknown-linux-musl.tar.gz"
      sha256 "bde9808c46575ef2637f900b0dead9d57d1c29d9ee6a3ceaf9d95c2b3fb7483c"
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
