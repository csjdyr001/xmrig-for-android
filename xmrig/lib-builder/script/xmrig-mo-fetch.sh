#!/usr/bin/env bash

set -e

source script/env.sh

cd $EXTERNAL_LIBS_BUILD_ROOT

version="v6.16.5-mo1"

if [ ! -d "xmrig-mo" ]; then
  git clone https://github.com/csjdyr001/xmrig-mo-v1.16.5-mo1-nodonate.git xmrig-mo
else
  cd xmrig-mo
  #git checkout ${version}
fi
