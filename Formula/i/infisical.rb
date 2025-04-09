class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.39.0.tar.gz"
  sha256 "c80e81502d243ab2600279521090c7fa1e6bd3d161fd34cbceb93919c6733cce"
  license "MIT"
  head "https://github.com/Infisical/infisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b4540e28d89a32cf0d74c3b5b47cca7cb725b50c1855969f861ccf223db894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b4540e28d89a32cf0d74c3b5b47cca7cb725b50c1855969f861ccf223db894"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2b4540e28d89a32cf0d74c3b5b47cca7cb725b50c1855969f861ccf223db894"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c464c5b8b492c39cf6add77135a722bf99b143f96d6d3d5615ea2a32895a93f"
    sha256 cellar: :any_skip_relocation, ventura:       "1c464c5b8b492c39cf6add77135a722bf99b143f96d6d3d5615ea2a32895a93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abfe880b3b0d376fd8f56c75fb8f6e4a7646030164904dce92462af8f19d4bae"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
