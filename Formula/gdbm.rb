class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.16.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.16.tar.gz"
  sha256 "c8a18bc6259da0c3eefefb018f8aa298fddc6f86c6fc0f0dec73270896ab512f"

  bottle do
    cellar :any
    sha256 "52f2c6347af039f27c0ecd3f1c5559fb215fc1f6ed0ca0ff1641f3267dd966e6" => :high_sierra
    sha256 "79d6094df951b8f008487becbe495bc82468e1af1991ae6fad2d2ded944322b1" => :sierra
    sha256 "b5d7bdd8b4ea746e87837d0f2b4b5af80296279ef284703355d8b9105c7e9400" => :el_capitan
    sha256 "74f6e18da9e7d20b46f75739b966c3cea4901f639df595679ed89cd91aba918d" => :x86_64_linux
  end

  if OS.mac?
    option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."
  else
    option "without-libgdbm-compat", "Do not build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."
  end

  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --without-readline
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    # GDBM uses some non-standard GNU extensions,
    # enabled with -D_GNU_SOURCE.  See:
    #   https://patchwork.ozlabs.org/patch/771300/
    #   https://stackoverflow.com/questions/5582211
    #   https://www.gnu.org/software/automake/manual/html_node/Flag-Variables-Ordering.html
    #
    # Fix error: unknown type name 'blksize_t'
    args << "CPPFLAGS=-D_GNU_SOURCE" unless OS.mac? || build.bottle?

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
