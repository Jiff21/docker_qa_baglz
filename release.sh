#!/bin/sh

set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=jiffcampbell
# image name
IMAGE=qa_baglz

# ensure we're up to date
git pull

# bump version
version=`cat VERSION`
echo "version: $version"

# run build
docker build . -t $IMAGE:$version

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $USERNAME/$IMAGE:latest
docker tag $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE
