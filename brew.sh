#!/usr/bin/env bash

# Install command-line tools using Homebrew.

### ~~~ ###
# for more on Mac: see http://sourabhbajaj.com/mac-setup/index.html
### ~~~ ###

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with macOS are outdated).
brew install coreutils
# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# Don’t forget to add `$(brew --prefix findutils)/libexec/gnubin` to `$PATH`.

# Install GNU `sed`, overwriting the built-in `sed`.
# brew install gnu-sed

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
brew install bash-completion

# Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Install `wget`
brew install wget

# Install RingoJS and Narwhal.
# Note that the order in which these are installed is important;
# see http://git.io/brew-narwhal-ringo.
# brew install ringojs
# brew install narwhal

# Install more recent versions of some macOS tools.
# brew install vim --with-override-system-vi
# brew install grep
# brew install gnupg 
# brew install gpg-agent 
# brew install openssh
# brew install pinentry-mac
# brew install screen

# Install cloud foundery -> https://docs.developer.swisscom.com/cf-cli/install-go-cli.html
# brew tap cloudfoundry/tap
# brew install cf-cli

# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
# brew install aircrack-ng
# brew install bfg
# brew install binutils
# brew install binwalk
# brew install cifer
# brew install dex2jar
# brew install dns2tcp
# brew install fcrackzip
# brew install foremost
# brew install hashpump
# brew install hydra
# brew install john
# brew install knock
# brew install netpbm
# brew install nmap
# brew install pngcheck
# brew install socat
# brew install sqlmap
# brew install tcpflow
# brew install tcpreplay
# brew install tcptrace
# brew install ucspi-tcp # `tcpserver` etc.
# brew install xpdf

# Install other useful binaries.
# brew install ack
brew install ansible                    # IT automation
# brew install consul
# brew install enca                       # to guess a file encoding
# brew install exiv2                      # image metadata library and tool
# brew install freetype                   # Software library to render fonts
brew install git                        # Distributed revision control system
# brew install git-lfs                    # Git extension for versioning large files
# brew install hub                        # CLI for github
# brew install hugo                       # static file CMS
# brew install go                         # programmation language
# brew install homebrew/php/php56 --with-gmp
# brew install heroku                     # CLI for heroku
# brew install imagemagick@6 --with-liblqr --with-webp
# brew install jq                         # CLI json processor
brew install libmagic                   # lib for image manipulation
# brew install lua
# brew install lynx                       # CLI web browser
# brew install libzip                     # C library for reading, creating, and modifying zip archives
# brew install node                       # Platform built on V8 to build network applications
# brew install p7zip                      # 7-Zip (high compression file archiver) implementation
# brew install pigz
# brew install pv
# to install latest python 3
# brew install python
# WARNING: there are some known issues with pyenv, check following wiki page to resolve them:
# https://github.com/pyenv/pyenv/wiki/Common-build-problems, e.g:
brew install pyenv
# PYTHON_CONFIGURE_OPTS="--with-tcl-tk" CFLAGS="-I$(xcrun --show-sdk-path)/usr/include" pyenv install 3.6.8
# CFLAGS="-I$(brew --prefix zlib)/include -I$(xcrun --show-sdk-path)/usr/include" LDFLAGS="-L$(brew --prefix zlib)/lib" pyenv install 3.6.8
# dependency for pyenv
# brew install readline
# brew install rename
# brew install rhino
brew install speedtest_cli
# brew install ssh-copy-id
# brew install testssl
brew install tree
# brew install vbindiff
# brew install webkit2png
# brew install watch
# brew install watchman
# dependency for pyenv
# brew install xz
# brew install zopfli
brew install zlib
# dependency for pillow
brew install libtiff libjpeg webp little-cms2

# dependencies for flutter
# brew install --HEAD usbmuxd
# brew install --HEAD libimobiledevice
# brew install ideviceinstaller ios-deploy cocoapods
# pod setup

# from cask
brew install 1password               # password manager
brew install 1password-cli           # password manager command line interface
brew install alfred                  # spotlight replacement
# brew install anaconda
brew install android-file-transfer   # file sync for android phones
# brew install android-studio        # dev editor
# brew install appcleaner
# brew install asepsis
brew install caffeine                # activate/deactivate screensaver from menu bar
# brew install carbon-copy-cloner    # backup manager
# brew install synology-drive
# brew install ccleaner
# brew install cheatsheet            # display all available shortcuts within context
brew install cleanmymac              # mac OS maintenance tool
# brew install db-browser-for-sqlite # Browser for SQLite DB files
brew install docker                  # container manager
# brew install doubletwist
brew install drawio                  # offline version of draw.io
brew install dropbox                 # file sync
# brew install evernote              # note manager
brew install firefox                 # web browser
# brew install flux
# brew install ghost                 # blog editor
brew install google-chrome           # web browser
# brew install google-earth-pro      # from google
# brew install google-hangouts
# brew install gpg-suite             # GPG keys tool box
brew install insomnia                # HTTP request (API) editor
brew install iterm2                  # terminal
brew install jq                      # json command line parser/formatter
brew install kdrive                  # Infomaniak cloud storage
# brew install latexian
# brew install licecap               # animated gif maker from screen
brew install meld                    # file/dir diff
brew install microsoft-office        # Microsoft Office for Mac + onedrive
brew install protonvpn               # VPN
# brew install xquartz               # Requirement for x2goclient
# brew install x2goclient            # fork of NoMachine for remote display (on units)
# brew install qlcolorcode           # enhance quicklook display
# brew install qlmarkdown            # enhance quicklook display
# brew install qlprettypatch         # enhance quicklook display
# brew install qlstephen             # enhance quicklook display
# brew install quicklook-csv         # enhance quicklook display
# brew install quicklook-json        # enhance quicklook display
brew install screenflick             # screen+sound recorder
brew install signal                  # Signal's messenger client
# brew install sketchup              # 3D editor
brew install skype                   # conference manager
brew install slack                   # collaborative work
brew install spectacle               # shortcut to resize/move windows
brew install spotify                 # audio player
brew install statusfy                # songs on-play by spotify dispayed in menu bar
brew install steam                   # game platform
# brew install sublime-text
# brew install suspicious-package
# brew install superduper
# brew install telegram               # conference
# brew install totalfinder
brew install transmission           # bit-torrent
# brew install valentina-studio       # video editor
brew install visual-studio-code     # dev editor
brew install vlc                    # video reader
brew install whatsapp               # what's app client
# brew install webpquicklook          # enhance quicklook display
# brew install x-lite                 # voice over IP client
brew install zoom                   # conference client
brew install menumeters             # CPU/RAM/IO indicators in menu bar

# Remove outdated versions from the cellar.
brew cleanup
