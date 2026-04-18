class DiskOrganiser < Formula
  desc "Visualise and safely organise files on your hard drive"
  homepage "https://github.com/krahd/disk_organiser"
  url "https://github.com/krahd/disk_organiser/releases/download/v0.1.1/disk-organiser-v0.1.1-macos-arm64-bin.tar.gz"
  sha256 "8cec1e55cc202c739b58a38100a5f53b971bf3db60be2a01bed3d3f9544bca70"
  license "MIT"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"disk-organiser").write <<~EOS
      #!/bin/bash
      exec "#{Formula[\"python@3.12\"].opt_bin}/python3" "#{libexec}/backend/app.py" ""
    EOS
    chmod 0755, bin/"disk-organiser"
  end

  test do
    assert_predicate libexec/"backend/app.py", :exist?
  end
end
