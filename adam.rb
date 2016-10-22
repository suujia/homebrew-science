class Adam < Formula
  desc "Genomics analysis platform built on Apache Avro, Apache Spark and Parquet"
  homepage "https://github.com/bigdatagenomics/adam"
  url "https://search.maven.org/remotecontent?filepath=org/bdgenomics/adam/adam-distribution-spark2_2.11/0.20.0/adam-distribution-spark2_2.11-0.20.0-bin.tar.gz"
  sha256 "f87beb379ee0ae1346d67cde374ba7b2416754ed690a2ada8b6b51a45e7717c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3bf8b2311b906535fca1048cfd64fd162b7d2d791a7814adc5d70ed7171b95fe" => :el_capitan
    sha256 "81b36880cc06e0822939358cfa631dae809cd632846e92b7e74d34a38d94a613" => :yosemite
    sha256 "a4cc0fae830a47294b6d83741cbbd5248c3707af8f8a56c418b886c66941424e" => :mavericks
  end

  head do
    url "https://github.com/bigdatagenomics/adam.git", :shallow => false
    depends_on "maven" => :build
  end

  option "without-test", "Disable build-time checking (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "apache-spark"

  def install
    if build.head?
      system "scripts/move_to_scala_2.11.sh"
      system "scripts/move_to_spark_2.sh"
      system "mvn", "clean", "package",
                    "-DskipTests=" + (build.with?("test") ? "False" : "True")
    end
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/adam-submit", "--version"
  end
end
