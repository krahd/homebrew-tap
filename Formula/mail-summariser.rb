class MailSummariser < Formula
  desc "Local-first mail workflow backend"
  homepage "https://github.com/krahd/Mail-Summariser"
  version "0.0.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krahd/Mail-Summariser/releases/download/v0.0.4/mail-summariser-backend-macos-arm64.tar.gz"
      sha256 "dec7ee9b4aab205ff9b97f2c96ef4a20edf496805a0124abcae2ed8323933d77"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/krahd/Mail-Summariser/releases/download/v0.0.4/mail-summariser-backend-linux-x64.tar.gz"
      sha256 "85ece14e58dafc03f6532c97350b6d1ac4e1197b906d1efa20215fd7c320b4c0"
    end
  end

  def install
    binary_name = if OS.mac?
      "mail-summariser-backend-macos-arm64"
    else
      "mail-summariser-backend-linux-x64"
    end

    libexec.install binary_name => "mail-summariser-backend"

    (bin/"mail-summariser").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ -z "${MAIL_SUMMARISER_DATA_DIR:-}" ]]; then
        if [[ "$(uname -s)" == "Darwin" ]]; then
          export MAIL_SUMMARISER_DATA_DIR="$HOME/Library/Application Support/MailSummariser"
        else
          export MAIL_SUMMARISER_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/mail-summariser"
        fi
      fi
      exec "#{libexec}/mail-summariser-backend" "$@"
    SH
    chmod 0755, bin/"mail-summariser"
  end

  test do
    shell_output("#{bin}/mail-summariser --help")
  end
end
