#!/bin/bash

# CONTEXT:
# pyenv install will require a --patch on Big Sur, depending on targeted version of python
# e.g. patch required for 3.7.<=4 and 3.8.<=3

# hence the definition of the function 'vercomp' which will adapt the command for 3.8.* versions

set -ex

# compare the version number to see whether patch need to be applied or not
# see https://stackoverflow.com/questions/4023830
vercomp () {
    if [[ $1 == $2 ]]
    then
        echo "="
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            echo ">"
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            echo "<"
            return 0
        fi
    done
    echo 0
    return 0
}


for version in "$@"
# for more explanation on "@*" see
# https://stackoverflow.com/questions/12314451
do 
    export CFLAGS="-I$(brew --prefix openssl)/include -I$(brew --prefix readline)/include -I$(xcrun --show-sdk-path)/usr/include";
    export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(xcrun --show-sdk-path)/usr/lib";
    result=$(vercomp $version "3.8.4")
    case $result in
        "=") pyenv install "$version" ;;
        ">") pyenv install "$version" ;;
        "<") pyenv install --patch "$version" < <(curl -sSL https://github.com/python/cpython/commit/8ea6353.patch);;
    esac    
done

# if any errors occur mentionning zlib, replace LDFLAGS line with the 3 following ones:
    # export LDFLAGS="-L$(brew --prefix openssl)/lib -L$(brew --prefix readline)/lib -L$(xcrun --show-sdk-path)/usr/lib -L/usr/local/opt/zlib/lib"
    # export CPPFLAGS="-I/usr/local/opt/zlib/include"
    # export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
