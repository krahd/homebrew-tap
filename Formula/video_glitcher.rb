class VideoGlitcher < Formula
  desc "Realtime desktop app for glitching video and exporting corrupted MP4 files"
  homepage "https://krahd.github.io/video_glitcher/"
  version "1.0.9"

  on_macos do
    url "https://github.com/krahd/video_glitcher/releases/download/v1.0.9/video_glitcher-macos-aarch64.zip"
    sha256 "8bf52476efde15a2b6adcc5188aceca286e69f7ba129d43c4c3ef1b78ed1d749"
  end

  on_linux do
    url "https://github.com/krahd/video_glitcher/releases/download/v1.0.9/video_glitcher-linux-amd64.zip"
    sha256 "4ab17a015110f5c5168f2e731e629423d494dd0cc945febbdf171b65c016161d"
  end

  depends_on "ffmpeg"
  depends_on "openjdk"

  def install
    if OS.mac? && !Hardware::CPU.arm?
      odie "video_glitcher only supports macOS Apple Silicon via Homebrew"
    end

    if OS.linux? && !Hardware::CPU.intel?
      odie "video_glitcher only supports Linux x86_64 via Homebrew"
    end

    release_dir = pkgshare/"video_glitcher"

    if (buildpath/"video_glitcher").directory?
      pkgshare.install "video_glitcher"
    else
      release_dir.install Dir["*"]
    end

    chmod 0755, release_dir/"run-macos.sh" if OS.mac?
    chmod 0755, release_dir/"run-linux.sh" if OS.linux?

    (bin/"video_glitcher").write <<~SH
      #!/bin/sh
      set -eu

      export PATH="#{Formula["ffmpeg"].opt_bin}:#{Formula["openjdk"].opt_bin}:$PATH"
      BASE_DIR="#{release_dir}"

      case "$(uname -s)" in
        Darwin)
          exec "$BASE_DIR/run-macos.sh" "$@"
          ;;
        Linux)
          exec "$BASE_DIR/run-linux.sh" "$@"
          ;;
        *)
          echo "Unsupported operating system: $(uname -s)" >&2
          exit 1
          ;;
      esac
    SH

    chmod 0755, bin/"video_glitcher"
  end

  test do
    assert_predicate pkgshare/"video_glitcher/video_glitcher.jar", :exist?
  end
end
