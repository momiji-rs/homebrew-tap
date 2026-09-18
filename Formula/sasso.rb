class Sasso < Formula
  desc "A pure-Rust SCSS to CSS compiler (a dart-sass alternative). Zero dependencies, wasm-friendly, embeddable as a library and usable as a CLI."
  homepage "https://github.com/momiji-rs/sasso"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.16.0/sasso-aarch64-apple-darwin.tar.xz"
      sha256 "602c6472d61ace042de3e38798c5efb72aaee1e076ee0996b10ac9ccffd3f6ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.16.0/sasso-x86_64-apple-darwin.tar.xz"
      sha256 "db718220fca727486a308f7a837dc183ebdc2a5fc71439066254627ca512ce78"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.16.0/sasso-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e85490d95fce0e8ce9b9376fa2f87ee1ffef6c0a280f2b154e7b93a2a9ae5a13"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.16.0/sasso-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9db3dda94ce3000f6ddf0b87b39fad70abd011a11a2b3a4d2bff6bd72b6c2bbd"
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
