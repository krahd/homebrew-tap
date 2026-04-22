class S2a < Formula
  desc "Migrate Squarespace sites into Astro-ready static content"
  homepage "https://github.com/krahd/squarespace-to-astro"
  version "0.5.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krahd/squarespace-to-astro/releases/download/v#{version}/s2a-#{version}-macos-arm64.tar.gz"
<<<<<<< HEAD
      sha256 "20e99abefac511827b2e3912950e797ed37bbd91d7b67c7d16076cef24cea92e"
=======
      sha256 "4a24fde6cf3b588be56f4ed960a1d2e33e1ea0cb0c4ccd5c918c5cf2f1558cb3"
>>>>>>> d907768 (homebrew: bump s2a to 0.5.4 and update checksums)
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/krahd/squarespace-to-astro/releases/download/v#{version}/s2a-#{version}-linux-x86_64.tar.gz"
      sha256 "0738e20310462baa30e547bbd9119400ff3d1e8d14ad66f3a72bdd8abb0ace09"
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
