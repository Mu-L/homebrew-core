class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.193.0.tgz"
  sha256 "f565446aa8cbc0e8adc3701ecf70e7fcf4b1512e6e9909d17b914f44e1754c0d"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6b64a1134f392e0bc263df8597189e91fd65614bdde19047523dfed2ed82913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874c121f99b2e3d426d3a44a2b1c27ca8ae15f0cad4da546336c8a95c1d53eba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a35899a6c3463925dbb464d96c35790f71d842d3b919111d64186613c36c617f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d89850b183cbf401faa747666b905f52a08671986989e2621ca02faf137f9a5"
    sha256 cellar: :any_skip_relocation, ventura:       "1b6b05f7fb0e37a5c8dc9b839e24d705b653c76e1462569f29d92c05fa67d85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14661644822817db0e21bf7f045ad2aaa558b961f8b451c2c03d65ccb808a244"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
