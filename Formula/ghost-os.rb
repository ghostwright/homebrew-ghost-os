class GhostOs < Formula
  desc "Full computer-use for AI agents. Self-learning workflows. Native macOS."
  homepage "https://github.com/ghostwright/ghost-os"
  url "https://github.com/ghostwright/ghost-os/releases/download/v2.0.5/ghost-os-2.0.5-macos-arm64.tar.gz"
  sha256 "6469da262bfe8a4cbbc151a7501283b451a8f27aca7075cfccff9fab81896b31"
  license "MIT"
  version "2.0.5"

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
        - Python 3.9+ with mlx and mlx_vlm (auto-configured by ghost setup)
        - ShowUI-2B model (~2.8 GB, downloaded during ghost setup)
        - The vision sidecar starts automatically when needed

      Check your setup:
        ghost doctor
    EOS
  end

  test do
    assert_match "Ghost OS v2", shell_output("#{bin}/ghost version")
  end
end
