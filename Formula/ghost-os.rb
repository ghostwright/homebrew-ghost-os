class GhostOs < Formula
  desc "Full computer-use for AI agents. Self-learning workflows. Native macOS."
  homepage "https://github.com/ghostwright/ghost-os"
  url "https://github.com/ghostwright/ghost-os/releases/download/v2.2.1/ghost-os-2.2.1-macos-arm64.tar.gz"
  sha256 "2ab2e11e54699c795c96fd09dd6a087f48b64261c9a7417c90646a2bd082cf64"
  license "MIT"
  version "2.2.1"

  def install
    bin.install "ghost"

    # Install ghost-vision launcher script (if present in tarball)
    bin.install "ghost-vision" if File.exist?("ghost-vision")

    # Install agent instructions
    (share/"ghost-os").install "GHOST-MCP.md"

    # Install bundled recipes
    (share/"ghost-os/recipes").install Dir["recipes/*.json"] if Dir.exist?("recipes")

    # Install vision sidecar (Python server + requirements)
    if Dir.exist?("vision-sidecar")
      (share/"ghost-os/vision-sidecar").install Dir["vision-sidecar/*"]
    end
  end

  # No post_install needed — ghost setup creates ~/.ghost-os/ at runtime

  def caveats
    <<~EOS
      Get started:
        ghost setup

      This configures permissions, connects to Claude Code, installs recipes,
      and sets up the vision system (ShowUI-2B model download + Python env).

      Ghost OS needs Accessibility permission for your terminal app.
      Screenshots need Screen Recording permission (optional).

      Vision grounding (ghost_ground) requires:
        - Python 3.10+ with mlx and mlx_vlm (auto-configured by ghost setup)
        - ShowUI-2B model (~3 GB, downloaded during ghost setup)
        - The vision sidecar starts automatically when needed

      Check your setup:
        ghost doctor
    EOS
  end

  test do
    assert_match "Ghost OS v2", shell_output("#{bin}/ghost version")
  end
end
