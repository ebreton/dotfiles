#!/bin/bash
CMD=${1:-git}
DIRS="${@/%/*}"

if [ $CMD = "git" ]
then
  echo "pulling $CMD only"
elif [ $CMD = "both" ]
then
  echo "pulling $CMD git and docker"
else
  echo "pass 'git' or 'both' as first arg"
  exit
fi

for dir in $DIRS
do
	:
    if [ -d "$dir/.git" ]; then
      echo "
> pulling $dir"
      cd $dir && git pull
      if [ -f docker-compose.yml ] && [ $CMD = "both" ];
      then
        docker-compose pull
      fi
      cd ..
    fi
done
