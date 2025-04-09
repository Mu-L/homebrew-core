class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.267",
      revision: "916aab28a7fabc925f99a921fb9e1e850ce0b6dc"
  license "Apache-2.0"
  head "https://github.com/aliyun/aliyun-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf0f8625e1cbe173878fc157135623eb7aad2a27d6f160ba4fc24f3ef59326b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf0f8625e1cbe173878fc157135623eb7aad2a27d6f160ba4fc24f3ef59326b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf0f8625e1cbe173878fc157135623eb7aad2a27d6f160ba4fc24f3ef59326b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7689d57d2185f36542a83f63eedeeb5c376b2ba92a4867713ab21cdf4ab7687d"
    sha256 cellar: :any_skip_relocation, ventura:       "7689d57d2185f36542a83f63eedeeb5c376b2ba92a4867713ab21cdf4ab7687d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85e63d611aac5c74c08b360ac0369733948e5f7695c6974fc7770c57e5b5508f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags:), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
