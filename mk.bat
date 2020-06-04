#!/bin/sh

# Slackware build script for "synergy".

# Copyright 2013-2016 Marcel Saegebarth <marc@mos6581.de>
# Copyright 2020 Christoph Willing  Brisbane, Australia
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

PRGNAM=synergy
SRCNAM=synergy-core
VERSION=${VERSION:-1.8.8m}
BUILD=${BUILD:-1}
TAG=${TAG:-_SBo}

if [ -z "$ARCH" ]; then
  case "$( uname -m )" in
    i?86) ARCH=i486 ;;
    arm*) ARCH=arm ;;
       *) ARCH=$( uname -m ) ;;
  esac
fi

CWD=$(pwd)
TMP=${TMP:-/tmp/SBo}
PKG=$TMP/package-$PRGNAM
OUTPUT=${OUTPUT:-/tmp}

if [ "$ARCH" = "i486" ]; then
  SLKCFLAGS="-O2 -march=i486 -mtune=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "i686" ]; then
  SLKCFLAGS="-O2 -march=i686 -mtune=i686"
  LIBDIRSUFFIX=""
elif [ "$ARCH" = "x86_64" ]; then
  SLKCFLAGS="-O2 -fPIC"
  LIBDIRSUFFIX="64"
else
  SLKCFLAGS="-O2"
  LIBDIRSUFFIX=""
fi

set -e

#rm -rf $PKG
mkdir -p $TMP $PKG $OUTPUT
#cd $TMP
#rm -rf $SRCNAM-$VERSION-stable
#tar xvf $CWD/$SRCNAM-$VERSION-stable.tar.gz
#cd $SRCNAM-$VERSION-stable
#patch -p0 < $CWD/010_include_dns_sd.diff
#patch -p0 < $CWD/020_toolchain_commands.diff

#chown -R root:root .
#find -L . \
# \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
#  -o -perm 511 \) -exec chmod 755 {} \; -o \
# \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
#  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;


case "$1" in
  init)
   sh hm.sh configure --generator=1 --release
   ;;
  all|make)
   CXXFLAGS="$SLKCFLAGS" sh hm.sh build
   ;;
  tgz)
# installation not implemented
mkdir -p $PKG/usr/bin $PKG/usr/doc/$PRGNAM-$VERSION $PKG/usr/man/man1 \
$PKG/usr/share/icons/hicolor/256x256 $PKG/usr/share/applications

for file in synergy synergyc synergyd synergys syntool usynergy ; do
  install -s -m 0755 $TMP/$SRCNAM-$VERSION-stable/bin/$file $PKG/usr/bin
done

for file in synergy.conf.example synergy.conf.example-advanced synergy.conf.example-basic ; do
  install -m 0644 $TMP/$SRCNAM-$VERSION-stable/doc/$file $PKG/usr/doc/$PRGNAM-$VERSION
done

for file in COMPILE ChangeLog INSTALL LICENSE README ; do
  install -m 0644 $TMP/$SRCNAM-$VERSION-stable/$file $PKG/usr/doc/$PRGNAM-$VERSION
done

for file in synergyc.man synergys.man ; do
  install -m 0644 $TMP/$SRCNAM-$VERSION-stable/doc/$file $PKG/usr/man/man1
done
find $PKG/usr/man/man1 -type f -name "*.man" -exec rename '.man' '.1' {} \;
find $PKG/usr/man/man1 -type f -name "*.?" -exec gzip -9f {} \;

install -m 0644 $TMP/$SRCNAM-$VERSION-stable/res/synergy.ico \
$PKG/usr/share/icons/hicolor/256x256

install -D -m 0644 $TMP/$SRCNAM-$VERSION-stable/res/synergy.desktop \
$PKG/usr/share/applications

cat $CWD/$PRGNAM.SlackBuild > $PKG/usr/doc/$PRGNAM-$VERSION/$PRGNAM.SlackBuild

mkdir -p $PKG/install
cat $CWD/slack-desc > $PKG/install/slack-desc
cat $CWD/doinst.sh > $PKG/install/doinst.sh

cd $PKG
/sbin/makepkg -l y -c n $OUTPUT/$PRGNAM-$VERSION-$ARCH-$BUILD$TAG.${PKGTYPE:-tgz}
   ;;
   *)
     echo "init|make|tgz"
     ;;
esac
