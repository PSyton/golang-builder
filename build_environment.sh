#!/bin/sh -e

tagName=$1

if ( find /src -maxdepth 0 | read v );
then
  echo "Error: Must mount Go source code into /src directory"
  exit 990
fi

# Grab Go package name
pkgName="$(go list -e -f '{{.ImportComment}}' 2>/dev/null || true)"

if [ -z "$pkgName" ];
then
    pkgName="$(git config --get remote.origin.url | sed -r s/.+alpe\\/\(.+\)\(.git\)$/github.com\\/alpe\\/\\1/g || true)"
fi

if [ -z "$pkgName" ];
then
  echo "Error: Must add canonical import path to root package"
  exit 992
fi

# Grab just first path listed in GOPATH
goPath="${GOPATH%%:*}"

# Construct Go package path
pkgPath="$goPath/src/$pkgName"

# Set-up src directory tree in GOPATH
mkdir -p "$(dirname "$pkgPath")"

# Link source dir into GOPATH
ln -sf /src "$pkgPath"

# change work dir to
cd $pkgPath

gpm install
