class DiskOrganiser < Formula
  desc "Visualise and safely organise files on your hard drive"
  homepage "https://github.com/krahd/disk_organiser"
  version "0.1.1"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/krahd/disk_organiser/releases/download/v0.1.1/disk-organiser-v0.1.1-macos-arm64-bin.tar.gz"
      sha256 "8cec1e55cc202c739b58a38100a5f53b971bf3db60be2a01bed3d3f9544bca70"
    else
      url "https://github.com/krahd/disk_organiser/releases/download/v0.1.1/disk-organiser-v0.1.1-macos-installer.tar.gz"
      sha256 "74043a3d1652be9ac4464ca48bd9bc6b539bd8dbc3c9b80c69c58830a83ccae9"
    end
  end

  on_linux do
    url "https://github.com/krahd/disk_organiser/releases/download/v0.1.1/disk-organiser-v0.1.1-linux-installer.tar.gz"
    sha256 "74043a3d1652be9ac4464ca48bd9bc6b539bd8dbc3c9b80c69c58830a83ccae9"
  end

  depends_on "python@3.12" unless Hardware::CPU.arm?

  def install
    if Hardware::CPU.arm?
      # archive contains bin/disk-organiser
      bin.install "disk-organiser"
    else
      # installer tarball contains installer/ with app files
      cd "installer" do
        libexec.install Dir["*"]
      end
      venv_dir = libexec/"venv"
      system Formula["python@3.12"].opt_bin/"python3", "-m", "venv", venv_dir
      system venv_dir/"bin/pip", "install", "--upgrade", "pip"
      if (libexec/"backend/requirements.txt").exist?
        system venv_dir/"bin/pip", "install", "-r", libexec/"backend/requirements.txt"
      end
      (bin/"disk-organiser").write <<~EOS
        #!/bin/bash
        exec "#{venv_dir}/bin/python" "#{libexec}/backend/app.py" "$@"
      EOS
      chmod 0755, bin/"disk-organiser"
    end
  end

  test do
    assert_predicate bin/"disk-organiser", :exist?
  end
end
