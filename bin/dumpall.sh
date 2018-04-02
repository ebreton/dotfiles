#!/bin/bash
if [ -z "$BACKUP" ]; then
    echo "set BACKUP env var with path to backup dir"
    exit 2
fi

cd $BACKUP
echo "working in $(pwd)..."

if [ -z "$SITES" ]; then
    echo "
no SITES provided: backup general context"
    echo "
> backup pmcconfig"
    docker run --rm -v pmcconfig:/pmcconfig -v $(pwd)/pmcconfig:/backup ebreton/w-rsync rsync -av /pmcconfig/ /backup
    exit 0
fi

SITES=( $SITES )
for i in "${SITES[@]}"
do
    :
    cd $DOCKING/../$i && make dump
done
