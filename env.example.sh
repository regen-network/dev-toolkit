#!/usr/bin/env bash

export CHAINID=regen
export NODE=http://127.0.0.1:26657
export DENOM=uregen

## copy binaries to regen-v2 ... if you need to test play with different versions
export APP=~/projects/regen/build/regen
export APP_HOME=~/.regen

## You can set a default keyring backend. Use your binary name instead of SIMD prefix
## possible values: pass, test
# export SIMD_KEYRING_BACKEND=test

## otherwise, if you want to use different keyring backend, you will need to specify:
# --keyring-backend test
