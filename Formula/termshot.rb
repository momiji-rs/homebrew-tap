class Termshot < Formula
  desc "Render a terminal session's final screen to PNG, text or JSON"
  homepage "https://github.com/momiji-rs/termshot"
  if OS.mac?
    url "https://github.com/momiji-rs/termshot/releases/download/v0.3.2/termshot-0.3.2-macos-universal.tar.gz"
    sha256 "3ee202601f67da05be3a67e270168b292520f857fb584840832ff2bfd54fe19c"
  elsif Hardware::CPU.arm?
    url "https://github.com/momiji-rs/termshot/releases/download/v0.3.2/termshot-0.3.2-linux-aarch64-musl.tar.gz"
    sha256 "d5775e33cc28c40ae10f6bfce446a9609644423d24e9d7e067b58f8582014475"
  else
    url "https://github.com/momiji-rs/termshot/releases/download/v0.3.2/termshot-0.3.2-linux-x86_64-musl.tar.gz"
    sha256 "8cbcbc9c3d20ae2e0b13423e3c02c5d32eaf9e080dfcae438a18c1a91009e41f"
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
