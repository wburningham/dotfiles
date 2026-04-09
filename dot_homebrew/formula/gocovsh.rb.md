class Gocovsh < Formula
  version "0.6.1"
  sha256 "3edb2b0bbc40fa371be415e7e80290d5e3549dffad857ffe979f36608d045d50"

  url "https://github.com/orlangure/gocovsh/releases/download/v#{version}/gocovsh_#{version}_darwin_arm64.tar.gz"
  head "https://github.com/orlangure/gocovsh.git", branch: "master"
  desc "Go Coverage in your terminal"
  homepage "https://github.com/orlangure/gocovsh"

  license "GPL-3.0"

  def install
    bin.install "gocovsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gocovsh -version")
  end
end
