class Termshot < Formula
  desc "Render a terminal session's final screen to PNG, text or JSON"
  homepage "https://github.com/momiji-rs/termshot"
  if OS.mac?
    url "https://github.com/momiji-rs/termshot/releases/download/v0.3.0/termshot-0.3.0-macos-universal.tar.gz"
    sha256 "920bb9ad86affb523d5347993a13cc4bfdb8211f0b080951104ee4fcc14e7992"
  elsif Hardware::CPU.arm?
    url "https://github.com/momiji-rs/termshot/releases/download/v0.3.0/termshot-0.3.0-linux-aarch64-musl.tar.gz"
    sha256 "6292dfbe5b074b34c6e739b4b443da0e3b2a04d3752fe2371315d81df3d9ccfd"
  else
    url "https://github.com/momiji-rs/termshot/releases/download/v0.3.0/termshot-0.3.0-linux-x86_64-musl.tar.gz"
    sha256 "8ad68aef1723d51f854f0af42c8e397c8a6b6231792a43563cc83dca1f3ce848"
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
