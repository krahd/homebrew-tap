class DiskOrganiser < Formula
  desc "Visualise and safely organise files on your hard drive"
  homepage "https://github.com/krahd/disk_organiser"
  url "https://github.com/krahd/disk_organiser/releases/download/v0.1.2-test-20260419061750/disk-organiser-v0.1.2-test-20260419061750-macos-arm64-bin.tar.gz"
  sha256 "cd131c6d683699d9c82979a65f6dd9ea3a25bec9dbe5b7086edb6058cb7dce49"
  license "MIT"

  def install
    bin.install "disk-organiser"
  end

  test do
    assert_predicate bin/"disk-organiser", :exist?
  end
end
