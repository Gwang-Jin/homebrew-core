class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.10.0.tar.gz"
  sha256 "db6c3a9e45408d2431bc3d1138a31b561fb71665c1d89db4b0cb3725b2b12faa"
  version_scheme 1
  head "https://github.com/dlang/dub.git"

  devel do
    url "https://github.com/dlang/dub/archive/v1.6.0-beta.2.tar.gz"
    sha256 "da1877c7c39a4905bca78083784733bfae59d60c7b665169d87fe2d81651b38f"
  end

  bottle do
    sha256 "502b6a1a71ad2011885eaf6172e20a5cf626e16c201357bb1072aab7f9b77ed7" => :high_sierra
    sha256 "18799640f91b1210ccd5d1349f34c1c91b32cf3603bc2ea442b68ce0694f74dd" => :sierra
    sha256 "30ae62ba7e76e4ec3e73e5454a3d96bb607bddee02af6a1e7644b077940dd52e" => :el_capitan
    sha256 "38c8cc2a0d11457efc21b7b3b8ea010b5f1de6c98cd85e192b51ca24f20ffa96" => :x86_64_linux
  end

  depends_on "pkg-config" => :recommended
  depends_on "dmd" => :build
  depends_on "curl" unless OS.mac?

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
