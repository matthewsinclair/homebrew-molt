# RENDERED by devbin's formula built-in from the template below, for the tag
# below and the commit it names: edit the template, not this file, which the
# next render replaces.
#   template  packaging/homebrew/molt.rb
#   tag       v1.4.2
#   commit    275ac8c6a2cb8734e1ff0fcb746f645c237906a5
class Molt < Formula
  desc "My Opinionated Local Terminal: a sleeve's shell, tools and agents from one stack"
  homepage "https://github.com/matthewsinclair/molt"
  url "https://github.com/matthewsinclair/molt.git",
      tag:      "v1.4.2",
      revision: "275ac8c6a2cb8734e1ff0fcb746f645c237906a5"
  license "MIT"

  # No depends_on "bash": Molt runs on macOS's own bash 3.2 as well as bash 5,
  # and CI's macOS runner proves it on every release tag.

  def install
    # Molt's own publish, run from the tag's checkout: it refuses a runtime set
    # that is not clean, copies what git names under bin/molt, lib/,
    # liberators/, templates/ and VERSION, and writes the manifest recording
    # that Homebrew owns this tree, so molt install refuses to write into it.
    system "bin/molt", "install", "--prefix", libexec, "--managed-by", "brew"
    # Linked into bin as every formula is, so a sleeve that never runs molt use
    # runs this install: no ~/.local/bin/molt means brew.
    bin.install_symlink libexec/"bin/molt"
  end

  def caveats
    <<~EOS
      With no ~/.local/bin/molt, this install is the molt you run.
      A maintainer with a dev checkout or an opt install switches with
        molt use dev
        molt use opt
      and comes back to this one with
        molt use brew
      which removes ~/.local/bin/molt. ~/.local/bin must come before
      #{HOMEBREW_PREFIX}/bin on PATH for the switch to take.
    EOS
  end

  test do
    assert_match "(brew, ", shell_output("#{bin}/molt version")
  end
end
