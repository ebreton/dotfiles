#!/bin/bash
DIRS="${@/%/*}"
for dir in $DIRS
do
    :
    cd $dir
    echo "trying $dir"
    if [ -f Makefile ];
    then
    make dump
    fi
    cd ..
    echo "."
done
