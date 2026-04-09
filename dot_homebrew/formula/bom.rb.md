class Bom < Formula
  sha256 "e3f7e468439a4e5a96006d4217bffdddc40165b2ccfb97329a95649509afd130"

  url "https://github.com/kubernetes-sigs/bom/releases/download/v0.6.0/bom-arm64-darwin"
  desc "bom is a little utility to generate & view SPDX manifests"
  homepage "https://github.com/kubernetes-sigs/bom"

  license "Apache License 2.0"

  def install
    bin.install Dir["*"].first => "bom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bom version")
  end
end
