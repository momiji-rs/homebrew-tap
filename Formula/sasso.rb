class Sasso < Formula
  desc "A pure-Rust SCSS to CSS compiler (a dart-sass alternative). Zero dependencies, wasm-friendly, embeddable as a library and usable as a CLI."
  homepage "https://github.com/momiji-rs/sasso"
  version "0.19.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.2/sasso-aarch64-apple-darwin.tar.xz"
      sha256 "fa737cdf3be5658d6727a1645931062c0541ed8f1e095cc0df8711bc7cd01f7b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.2/sasso-x86_64-apple-darwin.tar.xz"
      sha256 "51cce9392f7bd1c6a1b7a1ef21a80b6e96d2b4f161cb6d87e9e214c80e97c967"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.2/sasso-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0484227e79514d6b1264f703ab69f532f1e2c14b9d0eea9b64e59588cf6be322"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.2/sasso-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b86f8d817848bbf2e8537d23e8b291cb112078330e978f46f250b09466550853"
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
