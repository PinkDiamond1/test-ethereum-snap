#!/bin/sh
# We have a wrapper shell script since arguments can't be
# given from the snapcraft yaml and since we need selection
# of right architecture

verbose=true
platform=`uname -i`
plat_abi=

# map platform to multiarch triplet - manually
case $platform in
  x86_64)
    plat_abi=x86_64-linux-gnu
    ;;
  armv7l)
    plat_abi=arm-linux-gnueabihf
    ;;
  *)
    echo "unknown platform for snappy-magic: $platform. remember to file a bug or better yet: fix it :)"
    ;;
esac

# workaround that snappy services have bogus SNAP_ vars set; assume PWD is right
echo "$SNAP_APP_PATH" | grep -q SNAP_APP && SNAP_APP_PATH=$PWD
if test -z "$SNAP_APP_PATH"; then
  SNAP_APP_PATH=$PWD
fi

snapp_bin_path=$0
snapp_bin=`basename $snapp_bin_path`
snapp_dir=$SNAP_APP_PATH
snapp_name=`echo $snapp_bin | sed -e 's/\(.*\)[.]\([^.]*\)$/\1/g'`
snapp_org_bin=`echo $snapp_bin | sed -e 's/\(.*\)[.]\([^.]*\)$/\2/g'`

PATH="$snapp_dir/bin/$plat_abi/:$PATH"
LD_LIBRARY_PATH="$snapp_dir/lib/$plat_abi/:$LD_LIBRARY_PATH"
export PATH LD_LIBRARY_PATH

# make cwd the snapp dir
cd $snapp_dir

# fire the binary
# exec $snapp_bin /var/lib/apps/ethereum/current/.ethereum/geth.ipc
# temporary until the shared snap directory gets introduced
exec $snapp_bin /root/.ethereum/geth.ipc

# never reach this
exit 1
