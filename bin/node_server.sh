#!/bin/sh

export NODE_PATH=./lib/node_modules:$NODE_PATH
arm-node node_server.js
