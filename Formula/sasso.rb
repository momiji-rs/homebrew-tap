class Sasso < Formula
  desc "A pure-Rust SCSS to CSS compiler (a dart-sass alternative). Zero dependencies, wasm-friendly, embeddable as a library and usable as a CLI."
  homepage "https://github.com/momiji-rs/sasso"
  version "0.19.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.3/sasso-aarch64-apple-darwin.tar.xz"
      sha256 "3f8bf65c0242ee11605b707969afcc2753827124fdc58327c80ac30cf0e02a0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.3/sasso-x86_64-apple-darwin.tar.xz"
      sha256 "ccf19f51ab9819afc50ed1df23b4a683f5c3e95795f5a45b3fdf880c45460e53"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.3/sasso-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42856263b8c892c3f317ce8cf90c9886fc2bf72b47f0274747bafa564f746b39"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.19.3/sasso-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "696b205251669c1ffeed6530cb945a256f0d442d59b3e3de1ce64215441a99a9"
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
