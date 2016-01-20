#!/bin/sh
# We have a wrapper shell script since arguments can't be
# given from the snapcraft yaml
c-app-bin /var/lib/apps/ethereum/current/.ethereum/geth.ipc
