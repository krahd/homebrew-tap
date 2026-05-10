class MailSummariser < Formula
  desc "Local-first mail workflow backend"
  homepage "https://github.com/krahd/mail_summariser"
  version "0.1.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krahd/mail_summariser/releases/download/v0.1.3/mail_summariser-backend-macos-arm64.tar.gz"
      sha256 "65d3d4571002dbe3f400bc3063af2d1e9d3ae6da420ebfbc00a3c1d5e2d3a180"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/krahd/mail_summariser/releases/download/v0.1.3/mail_summariser-backend-linux-x64.tar.gz"
      sha256 "b12e42a8325fd397b65785a4e49518f9599b2738e87e8ef0942481c77112940f"
    end
  end

  def install
    binary_name = if OS.mac?
      "mail_summariser-backend-macos-arm64"
    else
      "mail_summariser-backend-linux-x64"
    end

    libexec.install binary_name => "mail_summariser-backend"

    (bin/"mail_summariser").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ -z "${MAIL_SUMMARISER_DATA_DIR:-}" ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
          export MAIL_SUMMARISER_DATA_DIR="$HOME/Library/Application Support/MailSummariser"
        else
          export MAIL_SUMMARISER_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mail_summariser"
        fi
      fi
      exec "#{libexec}/mail_summariser-backend" "$@"
    SH
    chmod 0755, bin/"mail_summariser"
  end

  test do
    shell_output("#{bin}/mail_summariser --help")
  end
end
