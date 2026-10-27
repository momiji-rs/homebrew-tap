class Termshot < Formula
  desc "Render a terminal session's final screen to PNG, text or JSON"
  homepage "https://github.com/momiji-rs/termshot"
  if OS.mac?
    url "https://github.com/momiji-rs/termshot/releases/download/v0.4.0/termshot-0.4.0-macos-universal.tar.gz"
    sha256 "4c649ac05a946aeaaca0b7a955ce1f0074b91c7ca5f044aaeebe54f83b480caa"
  elsif Hardware::CPU.arm?
    url "https://github.com/momiji-rs/termshot/releases/download/v0.4.0/termshot-0.4.0-linux-aarch64-musl.tar.gz"
    sha256 "a24d4bcdac6ac99e0d917c464b3a232b14d1c847d8c7a048119b07c7939471c4"
  else
    url "https://github.com/momiji-rs/termshot/releases/download/v0.4.0/termshot-0.4.0-linux-x86_64-musl.tar.gz"
    sha256 "ef966f4e04b6c50bc8b6c61cb2369fb9a9cd2d67ab03f77c4f118599eaf3e1f6"
  end
  license "MIT"

  def install
    bin.install "termshot"
  end

  test do
    assert_match "termshot #{version}", shell_output("#{bin}/termshot --version")
    (testpath/"in.pty").write "\e[1;31mhello\e[0m\r\n"
    system bin/"termshot", "--text", "out.txt", "in.pty", "out.png"
    assert_equal "\x89PNG".b, File.binread("out.png", 4)
    assert_match "hello", File.read("out.txt")
  end
end
