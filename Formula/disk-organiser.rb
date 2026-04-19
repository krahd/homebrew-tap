class DiskOrganiser < Formula
  desc "Visualise and safely organise files on your hard drive"
  homepage "https://github.com/krahd/disk_organiser"
  url "https://github.com/krahd/disk_organiser/releases/download/v0.1.1/disk-organiser-v0.1.1-macos-installer.tar.gz"
  sha256 "74043a3d1652be9ac4464ca48bd9bc6b539bd8dbc3c9b80c69c58830a83ccae9"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install Dir["installer/*"]
    venv_dir = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3", "-m", "venv", venv_dir
    system venv_dir/"bin/pip", "install", "--upgrade", "pip"
    system venv_dir/"bin/pip", "install", "-r", libexec/"backend/requirements.txt" if (libexec/"backend/requirements.txt").exist?
    (bin/"disk-organiser").write <<~EOS
      #!/bin/bash
      exec "#{venv_dir}/bin/python" "#{libexec}/backend/app.py" "$@"
    EOS
    chmod 0755, bin/"disk-organiser"
  end

  test do
    assert_predicate libexec/"backend/app.py", :exist?
  end
end
