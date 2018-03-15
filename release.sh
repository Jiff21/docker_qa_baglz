#!/bin/sh

set -ex
# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=jiffcampbell
# image name
IMAGE=qa_baglz

# ensure we're up to date
git pull

# bump version which provides something to commit.
old_version=`cat VERSION`
version=$(echo "x=$old_version + 0.1; if(x<1) print 0; x" | bc)
echo "Upgrading version from $old_version to version: $version"
echo "$version" > VERSION

# run build
docker build . -t $IMAGE:$version

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
docker tag $IMAGE:$version $USERNAME/$IMAGE:latest
docker tag $IMAGE:$version $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE
