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
brew install unrar
# brew install vbindiff
# brew install webkit2png
# brew install watch
# brew install watchman
# dependency for pyenv
# brew install xz
# brew install zopfli
# brew install zlib

# dependencies for flutter
# brew install --HEAD usbmuxd
# brew install --HEAD libimobiledevice
# brew install ideviceinstaller ios-deploy cocoapods
# pod setup

# from cask
brew install --cask 1password              # password manager
brew install --cask alfred                 # spotlight replacement
# brew install --cask anaconda
brew install --cask android-file-transfer  # file sync for android phones
# brew install --cask android-studio         # dev editor
# brew install --cask appcleaner
# brew install --cask asepsis
brew install --cask caffeine               # activate/deactivate screensaver from menu bar
# brew install --cask carbon-copy-cloner     # backup manager
# brew install --cask synology-drive
# brew install --cask ccleaner
# brew install --cask cheatsheet             # display all available shortcuts within context
brew install --cask cleanmymac             # mac OS maintenance tool
# brew install --cask db-browser-for-sqlite  # Browser for SQLite DB files
brew install --cask docker                 # container manager
# brew install --cask doubletwist
brew install --cask drawio                 # offline version of draw.io
brew install --cask dropbox                # file sync
# brew install --cask evernote               # note manager
brew install --cask firefox                # web browser
# brew install --cask flux
# brew install --cask ghost                  # blog editor
brew install --cask google-chrome          # web browser
# brew install --cask google-earth-pro       # from google
# brew install --cask google-hangouts
# brew install --cask gpg-suite              # GPG keys tool box
brew install --cask insomnia               # HTTP request (API) editor
brew install --cask iterm2                 # terminal
# brew install --cask latexian
brew install --cask meld                   # file/dir diff
# brew install --cask onedrive
brew install --cask protonvpn                # VPN
# brew install --cask qlcolorcode            # enhance quicklook display
# brew install --cask qlmarkdown             # enhance quicklook display
# brew install --cask qlprettypatch          # enhance quicklook display
# brew install --cask qlstephen              # enhance quicklook display
# brew install --cask quicklook-csv          # enhance quicklook display
# brew install --cask quicklook-json         # enhance quicklook display
brew install --cask screenflick            # screen+sound recorder
# brew install --cask sketchup               # 3D editor
brew install --cask skype                  # conference manager
brew install --cask slack                  # collaborative work
brew install --cask spectacle              # shortcut to resize/move windows
brew install --cask spotify                # audio player
brew install --cask statusfy               # songs on-play by spotify dispayed in menu bar
brew install --cask steam                  # game platform
# brew install --cask sublime-text
# brew install --cask suspicious-package
# brew install --cask superduper
# brew install --cask telegram               # conference
# brew install --cask totalfinder
brew install --cask transmission           # bit-torrent
# brew install --cask valentina-studio       # video editor
brew install --cask visual-studio-code     # dev editor
brew install --cask vlc                    # video reader
brew install --cask whatsapp               # what's app client
# brew install --cask webpquicklook          # enhance quicklook display
# brew install --cask x-lite                 # voice over IP client
brew install --cask zoom                   # conference client
brew install --cask menumeters             # CPU/RAM/IO indicators in menu bar

# Remove outdated versions from the cellar.
brew cleanup
