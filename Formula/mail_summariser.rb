class MailSummariser < Formula
  desc "Local-first mail workflow backend"
  homepage "https://github.com/krahd/mail_summariser"
  version "0.0.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/krahd/mail_summariser/releases/download/v0.0.5/mail_summariser-backend-macos-arm64.tar.gz"
      sha256 "8cc7adaab0692736d121e7ff04799d7110f59e95d10556254e86c202b5f0cdcc"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/krahd/mail_summariser/releases/download/v0.0.5/mail_summariser-backend-linux-x64.tar.gz"
      sha256 "13fceece8bed463712e554f879e942a052afaeafdd25998912a5b665e9ddc76d"
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
