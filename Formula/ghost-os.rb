class GhostOs < Formula
  desc "Full computer-use for AI agents. Self-learning workflows. Native macOS."
  homepage "https://github.com/ghostwright/ghost-os"
  url "https://github.com/ghostwright/ghost-os/releases/download/v2.0.1/ghost-os-2.0.1-macos-arm64.tar.gz"
  sha256 "d46854f2a9a9e226929ff47831206b65e1d7da16a695cd4a9299cc397329a3fb"
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
