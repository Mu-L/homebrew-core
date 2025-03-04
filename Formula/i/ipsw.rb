class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.580.tar.gz"
  sha256 "1ed4caa1fb477e42e6bd4c64bc31f185d2c7999810b16a5fab14eebc879d2bb9"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87aaa0a4f258c749ceb966f64053932856cd055bcc6f06355561a931caa0382f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea08d8843a67951688196280609bcfbe018e841dae19ab31c32cff8e4e07c230"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee6f381d715a9dcb8f63516a955a3aaec1df1e7f44f1cce959f8438a7f9b1264"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8b0009dbda88ce0e907f04a8e1db8d5df80b4eb1138baed5d1879701ab50c6b"
    sha256 cellar: :any_skip_relocation, ventura:       "d7df382a65ad3e716878276f76d8f52f48a998ea28679cbea7e5e35e88dcb470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd7d130e2606b96f46ac58bdfa2cdc7b1b9664a4d83faf835fa68d540dfd487"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
