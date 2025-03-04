class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://github.com/kubeshop/testkube/archive/refs/tags/v2.1.104.tar.gz"
  sha256 "b54dee5ff4218e296bf78b46dbb53a84a47ca3009d9ee608ee32b23722ead2b7"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc8f6b631f1663cc3d6959169119c4dabba8c1fd457216adf0f280bd54765d26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc8f6b631f1663cc3d6959169119c4dabba8c1fd457216adf0f280bd54765d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc8f6b631f1663cc3d6959169119c4dabba8c1fd457216adf0f280bd54765d26"
    sha256 cellar: :any_skip_relocation, sonoma:        "a57f67778296f68ea2bc92abd8ad992e34a80715dbc5590514608bf409021995"
    sha256 cellar: :any_skip_relocation, ventura:       "a57f67778296f68ea2bc92abd8ad992e34a80715dbc5590514608bf409021995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb07e24ee8f2a73fd2ba9df1e36aa7f9b798847ba2f0971fbec6a1b3f1d3144"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"kubectl-testkube"), "./cmd/kubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
