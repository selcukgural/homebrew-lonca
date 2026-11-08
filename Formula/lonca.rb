# Written by scripts/formula.sh from the SHA256SUMS of Lonca v0.2.0.
# Do not edit by hand: update.yml writes it again for every release.
class Lonca < Formula
  desc "Agent-native, Git-compatible version control"
  homepage "https://selcukgural.github.io/lonca/"
  version "0.2.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.0/lonca-aarch64-apple-darwin.tar.gz"
      sha256 "a383181c0d2aee05a89ad76a120b7deac8e26efb0973ef0837658a5f26ca69cb"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.0/lonca-x86_64-apple-darwin.tar.gz"
      sha256 "5162eec3b0e976bee598ef6e429ab64ac3d472c26e5c3f78eda67fd602482230"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.0/lonca-aarch64-unknown-linux-musl.tar.gz"
      sha256 "c3fa3ab9b8794870fc3ca4efa41d9dd3426ab69e497ab5a970bb61ad3b730d6d"
    end
    on_intel do
      url "https://github.com/selcukgural/lonca/releases/download/v0.2.0/lonca-x86_64-unknown-linux-musl.tar.gz"
      sha256 "1d3d9299cb139a06024cc58d1156025c50fbfdb7b763584a1008858bcec9a480"
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
