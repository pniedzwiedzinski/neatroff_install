#!/bin/sh

set -eu pipefail

[ ! -d /tmp/neatroff_make ] && \
	git clone https://github.com/aligrudi/neatroff_make /tmp/neatroff_make

cd /tmp/neatroff_make

sed -i '/^BASE/d;s/^#BASE/BASE/' Makefile
make init neat

BASE="/usr/local/bin"

sudo install neatroff/roff "$BASE/neatroff"
sudo install neatpost/post "$BASE/neatpost"
sudo install neatpost/pdf "$BASE/neatpost"
sudo install neateqn/eqn "$BASE/neateqn"
sudo install neatmkfn/mkfn "$BASE/neatmkfn"
sudo install neatrefer/refer "$BASE/neatrefer"
sudo install soin/soin "$BASE/soin"
sudo install shape/shape "$BASE/shape"
sudo install troff/pic/pic "$BASE/pic"
sudo install troff/tbl/tbl "$BASE/tbl"

BASE="/usr"
sudo install man/neateqn.1 "$BASE/share/man/man1"
sudo install man/neatmkfn.1 "$BASE/share/man/man1"
sudo install man/neatpost.1 "$BASE/share/man/man1"
sudo install man/neatrefer.1 "$BASE/share/man/man1"
sudo install man/neatroff.1 "$BASE/share/man/man1"

BASE="/opt/share/neatroff"
echo "Copying font descriptions to $BASE/tmac"
sudo mkdir "$BASE/tmac"
sudo cp -r tmac/* "$BASE/tmac/"
sudo find "$BASE/tmac" -type d -exec chmod 755 {} \;
sudo find "$BASE/tmac" -type f -exec chmod 644 {} \;
echo "Copying devutf device to $BASE/devutf"
sudo mkdir "$BASE/devutf"
sudo cp devutf/* "$BASE/devutf/"
sudo chmod 644 "$BASE/devutf"/*
echo "Copying fonts to $BASE/fonts"
sudo mkdir "$BASE/fonts"
sudo cp fonts/* "$BASE/fonts/"
sudo chmod 644 "$BASE/fonts"/*
echo "Updating fontpath in font descriptions"
for f in "$BASE/devutf"/*; do sudo sed "/^fontpath /s=$PWD/fonts=$BASE/devutf=" <$$f >.fd.tmp; sudo mv .fd.tmp $$f; done
