class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/dependency-check/DependencyCheck/releases/download/v12.1.2/dependency-check-12.1.2-release.zip"
  sha256 "404b7110a745ac0dd91eb3bcec7917a753487cad4b1da1717b91b327cf7a3454"
  license "Apache-2.0"
  head "https://github.com/dependency-check/DependencyCheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cdade93613029b1b5d7b4206f9cdc3563f8fb81062d1180dcf12317ee0cf7e77"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])

    chmod 0755, "bin/dependency-check.sh"
    libexec.install Dir["*"]

    (bin/"dependency-check").write_env_script libexec/"bin/dependency-check.sh",
      JAVA_HOME: Formula["openjdk"].opt_prefix

    (var/"dependencycheck").mkpath
    libexec.install_symlink var/"dependencycheck" => "data"

    (etc/"dependencycheck").mkpath
    jar = "dependency-check-core-#{version}.jar"
    corejar = libexec/"lib/#{jar}"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", libexec/"etc"
    (etc/"dependencycheck").install_symlink libexec/"etc/dependencycheck.properties"
  end

  test do
    # wait a random amount of time as multiple tests are being on different OS
    # the sleep 1 seconds to 30 seconds assists with the NVD Rate Limiting issues
    sleep(rand(1..30))
    output = shell_output("#{bin}/dependency-check --version").strip
    assert_match "Dependency-Check Core version #{version}", output

    (testpath/"temp-props.properties").write <<~EOS
      cve.startyear=2017
      analyzer.assembly.enabled=false
      analyzer.dependencymerging.enabled=false
      analyzer.dependencybundling.enabled=false
    EOS
    system bin/"dependency-check", "-P", "temp-props.properties", "-f", "XML",
              "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath,
              "--nvdDatafeed", "https://dependency-check.github.io/DependencyCheck/hb_nvd/",
              "--disableKnownExploited"
    assert_path_exists testpath/"dependency-check-report.xml"
  end
end
