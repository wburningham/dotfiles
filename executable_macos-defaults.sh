#!/bin/sh
# Sets reasonable macOS defaults.
#
# Derived from Nix darwin defaults configuration:
# https://github.com/caarlos0/dotfiles/blob/2025.6.2/machines/shared/darwin.nix

if [ "$(uname -s)" != "Darwin" ]; then
  exit 0
fi

set +e

sudo -v

echo ""
echo "> Start"

echo "› System"
echo "  › Set traditional scrolling"
defaults write -g com.apple.swipescrolldirection -bool false

echo "  › Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Use AirDrop over every interface"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "  › Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  › Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "  › Tint window background with wallpaper color"
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool false

echo "  › Disable smart quotes, smart dashes, and capitalization"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

echo "  › Set dark interface style"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"


echo "  › Save to disk by default, instead of iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Keep menu bar visible"
defaults write NSGlobalDomain _HIHideMenuBar -bool false

echo "  › Show Bluetooth icon in menu bar"
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

echo "  › Set springing delay to 0"
defaults write -g "com.apple.springing.delay" -float 0.0

echo "  › Set up trackpad & mouse speed"
defaults write -g com.apple.trackpad.scaling -int 2
defaults write -g com.apple.mouse.scaling -float 2.5

echo "  › Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -bool true
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  › Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  › Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  › Enable WebKit developer extras"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "  › Reduce motion"
defaults write com.apple.universalaccess reduceMotion -bool true

echo "  › Disable transparency"
defaults write com.apple.universalaccess reduceTransparency -bool true

# doesn't work on work computers
# echo "  › Set stone-color wallpaper"
# osascript -e 'tell application "System Events" to tell every desktop to set picture to "/System/Library/Desktop Pictures/Solid Colors/Stone.png"'


echo ""
echo "› Dock:"
echo "  › Don't automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool false

echo "  › Set Dock orientation to bottom"
defaults write com.apple.dock orientation -string "bottom"

echo "  › Setting the icon size of Dock items to 53 pixels"
defaults write com.apple.dock tilesize -int 53

# echo "  › Show hidden apps in the Dock"
# defaults write com.apple.dock showhidden -bool true

echo "  › Don't show recent applications in Dock"
defaults write com.apple.dock show-recents -bool false

echo "  › Show process indicators in Dock"
defaults write com.apple.dock show-process-indicators -bool true

# echo "  › Speed up Mission Control animations and group windows by application"
# defaults write com.apple.dock expose-animation-duration -float 0.1
# defaults write com.apple.dock expose-group-apps -bool true

echo "  › Don't animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "  › Set Dock mineffect to scale"
defaults write com.apple.dock mineffect -string "scale"

# echo "  › Don't automatically rearrange Spaces based on most recent use"
# defaults write com.apple.dock mru-spaces -bool false

echo "  › Make Dock size immutable"
defaults write com.apple.dock size-immutable -bool true



echo "› Safari"
echo "  › Set up Safari for development"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo "  › Show full URL in Smart Search field"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "  › Don't automatically open safe downloads"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "  › Set Safari homepage to blank"
defaults write com.apple.Safari HomePage -string ""

echo "  › Configure Safari session restoration"
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -int 1
defaults write com.apple.Safari ExcludePrivateWindowWhenRestoringSessionAtLaunch -int 1

# echo "  › Configure Safari favorites"
# defaults write com.apple.Safari ShowBackgroundImageInFavorites -int 0
# defaults write com.apple.Safari ShowFrequentlyVisitedSites -int 1
# defaults write com.apple.Safari ShowHighlightsInFavorites -int 1
# defaults write com.apple.Safari ShowPrivacyReportInFavorites -int 1
# defaults write com.apple.Safari ShowRecentlyClosedTabsPreferenceKey -int 1


echo ""
echo "› Restart related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Ghostty" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Terminal" "Photos" "Image Capture"; do
  killall "$app" >/dev/null 2>&1
done

set -e

echo "> Done; some changes need a restart to take effect"
