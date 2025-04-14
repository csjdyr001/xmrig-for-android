#!/usr/bin/env bash

set -e

source script/env.sh

cd $EXTERNAL_LIBS_BUILD_ROOT

#version="v6.17.0"

if [ ! -d "xmrig" ]; then
  git clone https://github.com/csjdyr001/xmrig.git
  cd ..
  cd ..
  #patch build/src/xmrig/src/net/strategies/DonateStrategy.cpp ./xmrig.patch --force
  sed -i -e "s/pthread rt dl log/dl/g" build/src/xmrig/CMakeLists.txt
 # sed -i -n -e 's/donate_user,/"4AioypVDDx8FbRzwRtBmxGQ27TRxPAJtS6KtLHQrPNmDHWQFGc8U3YD7x9s9EByDmYg8y48wRQ9mb36x7VMjtGyh5VkE4K8",/g'  build/src/xmrig/src/net/strategies/DonateStrategy.cpp

else
  cd ..
  cd ..
  #patch build/src/xmrig/src/net/strategies/DonateStrategy.cpp ./xmrig.patch --force
  #sed -i -n -e 's/86Xg9yRjmNSBSNsahTSvC4Edf6sqijTGfQqqkY6ACcruj8YFAmeJqP3XJM66A7f4P2dhQexNPoWhdLxaNQcNs4qmQNKGa5X/4AioypVDDx8FbRzwRtBmxGQ27TRxPAJtS6KtLHQrPNmDHWQFGc8U3YD7x9s9EByDmYg8y48wRQ9mb36x7VMjtGyh5VkE4K8/g'  build/src/xmrig/src/net/strategies/DonateStrategy.cpp
fi
