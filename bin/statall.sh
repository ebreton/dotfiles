#!/bin/bash
CMD=${1:-status}
DIRS="${@/%/*}"

for dir in $DIRS
do
	:
    if [ -d "$dir/.git" ]; then
        echo "
> checking $dir"
        cd $dir && git $CMD
        cd ..
    fi
done
