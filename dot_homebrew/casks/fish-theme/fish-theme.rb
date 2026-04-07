cask "fish-theme" do

  config_filename = ".config/fish/themes/Catppuccin Mocha.theme"

  version :latest
  name "fish-theme"
  desc "Cask to install github.com/catppuccin/fish Catppuccin Mocha.them"
  homepage "https://github.com/catppuccin/fish"
  
  url "https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Mocha.theme"
  sha256 :no_check

  config_filename_base = File.basename(config_filename)

  preflight do
    # Find the downloaded file (may have URL-encoded name or be named after the domain)
    theme_file = Dir.glob("#{staged_path}/*").find { |f| File.basename(f).end_with?(".theme") || File.basename(f) == "Catppuccin%20Mocha.theme" }
    if theme_file && File.basename(theme_file) != config_filename_base
      FileUtils.mv theme_file, "#{staged_path}/#{config_filename_base}"
    end
  end
  
  # Copy the staged config to the home directory
  artifact "#{staged_path}/#{config_filename_base}", target: "#{ENV['HOME']}/#{config_filename}"
end

