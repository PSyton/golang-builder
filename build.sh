#!/bin/bash -e

source /build_environment.sh

godep go test -coverprofile cover.out -v ./...

godep go tool cover -html=cover.out -o cover.html

godep go vet ./... > go_vet.txt
golint ./... > golint.txt

# Compile statically linked version of package
echo "Building $pkgName"
`CGO_ENABLED=${CGO_ENABLED:-0} godep go build -a --installsuffix cgo --ldflags="${LDFLAGS:--s}" $pkgName`

# Grab the last segment from the package name
name=${pkgName##*/}

if [[ $COMPRESS_BINARY == "true" ]];
then
  goupx $name
fi

if [ -e "/var/run/docker.sock" ] && [ -e "./Dockerfile" ];
then
  # Default TAG_NAME to package name if not set explicitly
  tagName=${tagName:-"$name":latest}

  # Build the image from the Dockerfile in the package directory
  docker build -t $tagName .
fi
