class VideoGlitcher < Formula
  desc "Realtime desktop app for glitching video and exporting corrupted MP4 files"
  homepage "https://krahd.github.io/video_glitcher/"
  version "1.0.7"

  on_macos do
    url "https://github.com/krahd/video_glitcher/releases/download/v1.0.7/video_glitcher-macos-aarch64.zip"
    sha256 "ce9f38693d8fe47e9f2dfff38da609d5c938bfdf2a180c591e04bf891c6f0f1d"
  end

  on_linux do
    url "https://github.com/krahd/video_glitcher/releases/download/v1.0.7/video_glitcher-linux-amd64.zip"
    sha256 "c9c367e0e8da2fa4280378688ac56b1b4abddff5bd54c26f378b29a8665f4004"
  end

  depends_on "ffmpeg"
  depends_on "openjdk"

  def install
    if OS.mac? && !Hardware::CPU.arm?
      odie "video-glitcher only supports macOS Apple Silicon via Homebrew"
    end

    if OS.linux? && !Hardware::CPU.intel?
      odie "video-glitcher only supports Linux x86_64 via Homebrew"
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
