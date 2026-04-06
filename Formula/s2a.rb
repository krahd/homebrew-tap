class S2a < Formula
  desc "Migrate Squarespace sites into Astro-ready static content"
  homepage "https://github.com/krahd/squarespace-to-astro"
  version "0.2.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krahd/squarespace-to-astro/releases/download/v#{version}/s2a-#{version}-macos-arm64.tar.gz"
      sha256 "ec2d77bc3903f8be6d441ce9b694c64d66b90b468581c8cbd149ae7b7d241b08"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/krahd/squarespace-to-astro/releases/download/v#{version}/s2a-#{version}-linux-x86_64.tar.gz"
      sha256 "96313141853158b31ba3b0b15e14b4ec6fd6fa14a791a856ec534a57a88d3100"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      odie "Homebrew installation is not yet available for macOS Intel. Use the GitHub release archive instead."
    end

    if OS.linux? && !Hardware::CPU.intel?
      odie "Homebrew installation is currently available only for Linux x86_64. Use the GitHub release archive instead."
    end

    archive_name = if OS.mac?
      "s2a-#{version}-macos-arm64.tar.gz"
    else
      "s2a-#{version}-linux-x86_64.tar.gz"
    end

    pkgshare.install cached_download => archive_name

    (bin/"s2a").write <<~SH
      #!/bin/bash
      set -euo pipefail

      archive="#{opt_pkgshare}/#{archive_name}"

      if [[ "$(uname -s)" == "Darwin" ]]; then
        cache_root="$HOME/Library/Caches/s2a/homebrew/#{version}"
      else
        cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/s2a/homebrew/#{version}"
      fi

      mkdir -p "$cache_root"
      bundle_dir=$(find "$cache_root" -mindepth 1 -maxdepth 1 -type d -name 's2a-*' | head -n 1)

      if [[ -z "$bundle_dir" ]]; then
        tar -xzf "$archive" -C "$cache_root"
        bundle_dir=$(find "$cache_root" -mindepth 1 -maxdepth 1 -type d -name 's2a-*' | head -n 1)
      fi

      if [[ -z "$bundle_dir" || ! -x "$bundle_dir/s2a" ]]; then
        echo "s2a bundle extraction failed" >&2
        exit 1
      fi

      exec "$bundle_dir/s2a" "$@"
    SH

    chmod 0755, bin/"s2a"
  end

  test do
    assert_match "Probe, extract, and generate", shell_output("#{bin}/s2a --help")
  end
end
