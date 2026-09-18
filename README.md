# momiji-rs/homebrew-tap

A [Homebrew](https://brew.sh) tap for [momiji-rs](https://github.com/momiji-rs)
command-line tools.

## Install

```console
$ brew install momiji-rs/tap/sasso
$ sasso --version
```

Use that fully qualified form. Since [Homebrew
6.0.0](https://brew.sh/2026/06/11/homebrew-6.0.0/) a non-official tap is not
trusted by default, and installing `owner/tap/formula` trusts **only that
formula** — no separate `brew trust` step, and nothing else in this tap (now or
later) becomes loadable. `brew tap momiji-rs/tap` followed by `brew install
sasso` needs `brew trust --formula momiji-rs/tap/sasso` in between. See
[Tap Trust](https://docs.brew.sh/Tap-Trust).

## Formulae

| formula | what |
|---|---|
| [`sasso`](Formula/sasso.rb) | A pure-Rust SCSS/Sass → CSS compiler, byte-for-byte compatible with dart-sass. [momiji-rs/sasso](https://github.com/momiji-rs/sasso) |

The formulae install the **prebuilt binaries** attached to each upstream
release — macOS and Linux, arm64 and x86_64 — verified against a SHA-256
recorded in the formula. There is nothing to compile, so this tap ships no
bottles.

## Why this tap exists

Homebrew [prefers to keep software in
`homebrew/core`](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap#upstream-taps),
where it is autobumped and discoverable, and so do we. `homebrew/core` requires
a package to [demonstrate public interest beyond its
author](https://docs.brew.sh/Package-Acceptance-Policy#notability): 30 forks, 30
watchers or 75 stars, and 90/90/225 for a submission by the repository owner.
sasso is not there yet. This tap is how you can `brew install` it in the
meantime, not an argument against core — if sasso ever clears the bar, core is
where it should live.

## How a formula gets here

Nobody writes the Ruby. Each `momiji-rs/*` release is built by
[`dist`](https://github.com/axodotdev/cargo-dist), which renders the formula
with the release's own SHA-256 checksums and attaches it to the GitHub Release.
[`sync-formula.yml`](.github/workflows/sync-formula.yml) in *this* repo then
pulls that artifact and commits it.

The direction is deliberate. `dist` can push the formula here from the upstream
repo, but that needs a cross-repo write token kept as a secret over there.
Reading a public repo's releases needs no credential, so the tap pulls and
commits with its own built-in `GITHUB_TOKEN` instead. **Neither repo holds a
secret.** The sync refuses to commit a formula that is not the expected class,
whose `version` disagrees with the tag it came from, or that is missing any of
its four `sha256` lines — the last of which is what a partially built release
looks like, and would otherwise mean Homebrew installing an unverified
download.

It runs every 3 hours (the cadence Homebrew's own autobump uses) and on demand:

```console
$ gh workflow run sync-formula --repo momiji-rs/homebrew-tap
```

⚠️ GitHub disables `schedule` triggers in a repository with no commits for 60
days. This tap only commits when something upstream releases, so a long quiet
spell will stop the cron silently. A manual run works regardless and re-arms
the schedule.

## Licence

The formulae are MIT OR Apache-2.0, matching the software they install.
