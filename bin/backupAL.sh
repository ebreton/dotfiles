#!/bin/bash
SITES_AL="bernardginisty cesaremongodi silviainstitut semencedamour atelier-magnolia annelaure-art"

if [ -z "$SITES_AL" ]; then
    echo "
no SITES_AL provided"
    exit 1
fi

cd ~/git-repos
echo "working in $(pwd)..."

HOST_AL="root@79.137.37.116"
SITES_AL=( $SITES_AL )
for i in "${SITES_AL[@]}"
do
    :
    echo "
> backup $i HTML
rsync -av --exclude=.git --update --delete $i/html $HOST_AL:backup-worpdress/html/$i
"
    rsync -av --exclude=.git --update --delete $i/html $HOST_AL:backup-worpdress/html/$i

    echo "
> backup $i DB
scp $i/dbdata/dump_$i.sql $HOST_AL:backup-worpdress/dbdata/
"
    scp $i/dbdata/dump_$i.sql $HOST_AL:backup-worpdress/dbdata/
done
