#!/usr/bin/env zsh
zip -r package.zip res/* src/*
VER=`date "+%Y%m%d-%H:%M:%S"`
echo "update package version $VER"
echo $VER > version
git add package.zip version
git commit -m $VER
git push origin master
ssh ubuntu@112.124.52.120 'cd /var/www/public/images/circus/ && git pull'
