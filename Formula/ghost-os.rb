class GhostOs < Formula
  desc "Full computer-use for AI agents. Self-learning workflows. Native macOS."
  homepage "https://github.com/ghostwright/ghost-os"
  url "https://github.com/ghostwright/ghost-os/releases/download/v2.0.1/ghost-os-2.0.1-macos-arm64.tar.gz"
  sha256 "8f4aa4d4855eb3f2f8eeadffbc478a3c7056e1caea6c957ccda4877a9baf6671"
  license "MIT"
  version "2.0.1"

  depends_on :macos
  depends_on macos: :sonoma

  def install
    bin.install "ghost"

    # Install agent instructions
    share.install "GHOST-MCP.md"

    # Install bundled recipes
    (share/"ghost-os/recipes").install Dir["recipes/*.json"] if Dir.exist?("recipes")
  end

  def post_install
    # Create user recipes directory
    (var/"ghost-os").mkpath
  end

  def caveats
    <<~EOS
      Get started:
        ghost setup

      This configures permissions, connects to Claude Code, and installs recipes.

      Ghost OS needs Accessibility permission for your terminal app.
      Screenshots need Screen Recording permission (optional).
    EOS
  end

  test do
    assert_match "Ghost OS v2", shell_output("#{bin}/ghost version")
  end
end
