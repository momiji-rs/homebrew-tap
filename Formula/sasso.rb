class Sasso < Formula
  desc "A pure-Rust SCSS to CSS compiler (a dart-sass alternative). Zero dependencies, wasm-friendly, embeddable as a library and usable as a CLI."
  homepage "https://github.com/momiji-rs/sasso"
  version "0.17.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.17.0/sasso-aarch64-apple-darwin.tar.xz"
      sha256 "51293b488cb6f6de9847e6528a7cd195f4ad1eefd5ad3806c8b1bd463f87017d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.17.0/sasso-x86_64-apple-darwin.tar.xz"
      sha256 "ede5618b82dbea9a0e0e3d83237143fe853e95d4b196c3cbf39e2c62f24bd1c2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.17.0/sasso-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ae1ff8e58e0a66df5575967e5da3c0461784b4d4770ecb5abbc535b8d3c3f0ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/momiji-rs/sasso/releases/download/v0.17.0/sasso-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f72cddebaec498e81beac48e0c155f423fa50a547881cc4be4053b25d7c24310"
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
