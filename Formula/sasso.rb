class Sasso < Formula
  desc "A pure-Rust SCSS to CSS compiler (a dart-sass alternative). Zero dependencies, wasm-friendly, embeddable as a library and usable as a CLI."
  homepage "https://github.com/momiji-rs/sasso"
  version "0.21.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.21.0/sasso-aarch64-apple-darwin.tar.xz"
      sha256 "6e09712b862cd37ad1531d9a0c31377ab31f89d0f01ba0c273f9f3acf0fd2a2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.21.0/sasso-x86_64-apple-darwin.tar.xz"
      sha256 "483f7471ef96900123a0069348225b84c031c1c17171daa9761a8edfa892a9b6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.21.0/sasso-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "00938e7df374cfe39e6c0814aa76710d1e1af71c6394744ba447ea090b499bcf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.21.0/sasso-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "12b38ba3f9a54cf907a5d4315a1ad55b2dffeb96d1a169dbcf9b77f3253c3da6"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sasso"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sasso"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sasso"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sasso"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
