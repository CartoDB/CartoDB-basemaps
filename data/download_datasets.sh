#!/bin/sh -ex

DIR=ne_temp
mkdir -p ne_temp

set -e

for url in $(cat datasets.txt)
do
  wget -P $DIR/ $url
done

for z in $DIR/*.zip; do unzip $z -d $DIR/; done
