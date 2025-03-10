class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.53.1.tar.gz"
  sha256 "f0ce7df6f50555439242dd12c2a71f5838590fda683c364428091fff7929efc0"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7599ba082bc1e3df62101179067905c6fc5aea5e788ff8538a9af409de2e44af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7599ba082bc1e3df62101179067905c6fc5aea5e788ff8538a9af409de2e44af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7599ba082bc1e3df62101179067905c6fc5aea5e788ff8538a9af409de2e44af"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8989ae13a025ff8f3169818d9fb1f09f3c4b742259e056c66c00923af113dea"
    sha256 cellar: :any_skip_relocation, ventura:       "f8989ae13a025ff8f3169818d9fb1f09f3c4b742259e056c66c00923af113dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2750132c65d43dd16fa15f58b9940089695bbffb78525a9c49027cb74db21e57"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
