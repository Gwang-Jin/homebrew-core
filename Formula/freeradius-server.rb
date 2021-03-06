class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "ftp://ftp.freeradius.org/pub/freeradius/freeradius-server-3.0.17.tar.bz2"
  sha256 "3f03404b6e4a4f410e1f15ea2ababfec7f8a7ae8a49836d8a0c137436d913b96"
  head "https://github.com/FreeRADIUS/freeradius-server.git"

  bottle do
    sha256 "038ea0b2497cf0460473eb660fe8dc770cfa7e1d9fc603015194e6a9c3a8dfd0" => :high_sierra
    sha256 "2ef3f4689ca57e28836b3501a520b731b5510e7ec62a601ae6af4f1bec54067d" => :sierra
    sha256 "4a8d696e3532c98b027a6fb9e4b9a8a6472a80800c187902cbd5d37d44579fe7" => :el_capitan
    sha256 "cf1e499abf96f97aec00a50699f25f877c3a1f99ebfd87f4e13bbff722ea8fb6" => :x86_64_linux
  end

  depends_on "openssl"
  depends_on "talloc"
  depends_on "perl" unless OS.mac?

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{Formula["openssl"].opt_include}
      --with-openssl-libraries=#{Formula["openssl"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    output = shell_output("#{bin}/smbencrypt homebrew")
    assert_match "77C8009C912CFFCF3832C92FC614B7D1", output
  end
end
