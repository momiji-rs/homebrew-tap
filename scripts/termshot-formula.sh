#!/bin/sh
# Write Formula/termshot.rb for one termshot release to stdout:
#
#   scripts/termshot-formula.sh v0.3.0 SHA256SUMS > Formula/termshot.rb
#
# termshot's release attaches no formula, only its archives and SHA256SUMS, so
# the formula is rendered here from the checksums. Fails, printing nothing, if
# SHA256SUMS lacks any of the three archives.
set -eu
tag=${1:?usage: scripts/termshot-formula.sh TAG SHA256SUMS}
sums=${2:?usage: scripts/termshot-formula.sh TAG SHA256SUMS}
version=${tag#v}
base="https://github.com/momiji-rs/termshot/releases/download/$tag"

sha() {
    archive="termshot-$version-$1.tar.gz"
    s=$(awk -v f="$archive" '$2 == f || $2 == "*" f { print $1 }' "$sums")
    printf '%s\n' "$s" | grep -Eqx '[0-9a-f]{64}' \
        || { echo "no sha256 for $archive in $sums" >&2; exit 1; }
    printf '%s\n' "$s"
}
mac=$(sha macos-universal)
linux_arm=$(sha linux-aarch64-musl)
linux_intel=$(sha linux-x86_64-musl)

cat <<RUBY
class Termshot < Formula
  desc "Render a terminal session's final screen to PNG, text or JSON"
  homepage "https://github.com/momiji-rs/termshot"
  if OS.mac?
    url "$base/termshot-$version-macos-universal.tar.gz"
    sha256 "$mac"
  elsif Hardware::CPU.arm?
    url "$base/termshot-$version-linux-aarch64-musl.tar.gz"
    sha256 "$linux_arm"
  else
    url "$base/termshot-$version-linux-x86_64-musl.tar.gz"
    sha256 "$linux_intel"
  end
  license "MIT"

  def install
    bin.install "termshot"
  end

  test do
    assert_match "termshot #{version}", shell_output("#{bin}/termshot --version")
    (testpath/"in.pty").write "\\e[1;31mhello\\e[0m\\r\\n"
    system bin/"termshot", "--text", "out.txt", "in.pty", "out.png"
    assert_equal "\\x89PNG".b, File.binread("out.png", 4)
    assert_match "hello", File.read("out.txt")
  end
end
RUBY
