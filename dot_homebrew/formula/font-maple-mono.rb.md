cask "font-maple-mono" do
  version :latest

  name "Maple Mono"
  homepage "https://font.subf.dev/en/"

  url "file://#{__dir__}/files/MapleMono-Regular.ttf?v=#{Time.now.to_i}"
  sha256 :no_check

  preflight do
    # Copy to staging directory because installing an artifact creates a symlink
    # and when you uninstall the file is deleted, but we don't want to delete the original
    # config
    # FileUtils.cp "#{__dir__}/files/MapleMono-Italic.ttf", "#{staged_path}/MapleMono-Italic.ttf"
    FileUtils.cp "#{__dir__}/files/MapleMono-Regular.ttf", "#{staged_path}/MapleMono-Regular.ttf"
  end

  # Copy the staged fonts to the font directory
  # font "#{staged_path}/MapleMono-Italic.ttf"
  font "#{staged_path}/MapleMono-Regular.ttf"

  # No zap stanza required
end
