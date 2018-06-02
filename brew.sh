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
brew install gnu-sed --with-default-names

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

# Install `wget` with IRI support.
brew install wget --with-iri

# Install RingoJS and Narwhal.
# Note that the order in which these are installed is important;
# see http://git.io/brew-narwhal-ringo.
# brew install ringojs
# brew install narwhal

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install gnupg 
brew install gpg-agent 
brew install openssh
brew install pinentry-mac
brew install screen

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
# brew install xz

# Install other useful binaries.
# brew install ack
# brew install dark-mode
brew install exiv2
brew install flake8
brew install freetype
brew install git
brew install git-lfs
brew install hub
brew install hugo
brew install imagemagick@6 --with-liblqr --with-webp
# brew install lua
brew install lynx
brew install p7zip
brew install libzip
brew install node
brew install watchman
# brew install pigz
# brew install pv
brew install python3
# brew install rename
# brew install rhino
brew install speedtest_cli
# brew install ssh-copy-id
brew install testssl
brew install tree
brew install vbindiff
brew install webkit2png
# brew install zopfli
# brew install homebrew/php/php56 --with-gmp
brew install go
brew install ansible
# brew install consul
brew install watch
brew install unrar
brew install heroku

# from cask
# Quick look plugins
brew cask install qlcolorcode
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install suspicious-package
brew cask install webpquicklook
# apps
brew cask install 1password
brew cask install alfred
brew cask install android-file-transfer
brew cask install appcleaner
# brew cask install asepsis
brew cask install caffeine
brew cask install carbon-copy-cloner
brew cask install synology-drive
brew cask install ccleaner
brew cask install cheatsheet
brew cask install docker
brew cask install doubletwist
brew cask install dropbox
brew cask install firefox
# brew cask install flux
brew cask install ghost
brew cask install google-chrome
brew cask install google-earth-pro
# brew cask install google-hangouts
brew cask install gpg-suite
brew cask install iterm2
# brew cask install latexian
brew cask install meld
brew cask install onedrive
brew cask install screenflick
brew cask install spectacle
brew cask install spotify
brew cask install sketchup
brew cask install skype
brew cask install statusfy
brew cask install sublime-text
# brew cask install superduper
brew cask install telegram
# brew cask install totalfinder
brew cask install transmission
brew cask install valentina-studio
brew cask install visual-studio-code
brew cask install vlc
brew cask install whatsapp
brew cask install zoomus
brew cask install yujitach-menumeters

# Remove outdated versions from the cellar.
brew cleanup
