class ChatgptToClaude < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for reviewing and migrating ChatGPT exports into Claude-friendly bundles"
  homepage "https://github.com/krahd/chatgpt_to_claude"
  url "https://github.com/krahd/chatgpt_to_claude/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "45ecf0a5bee9050c81485b6a487d3fa977b96aae11bb00a8948dd3b4394c92a1"
  license "MIT"

  bottle do
    root_url "https://github.com/krahd/homebrew-tap/releases/download/v0.0.2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c0e98832cdd5c31593e9db5370444c50a0ece5ee652c62ff9cb7e4aadb46bf35"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_path_exists bin/"chatgpt-to-claude"
  end
end
