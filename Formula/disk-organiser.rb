class DiskOrganiser < Formula
  desc "Visualise and safely organise files on your hard drive"
  homepage "https://github.com/krahd/disk_organiser"
  url "https://github.com/krahd/disk_organiser/releases/download/v0.1.1/#{MAC_TAR_NAME}"
  sha256 "74043a3d1652be9ac4464ca48bd9bc6b539bd8dbc3c9b80c69c58830a83ccae9"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"disk-organiser").write <<~EOS
      #!/bin/bash
      exec "/python3" "#{libexec}/backend/app.py" ""
    EOS
    chmod 0755, bin/"disk-organiser"
  end

  test do
    assert_predicate libexec/"backend/app.py", :exist?
  end
end
