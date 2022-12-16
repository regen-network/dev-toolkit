#!/usr/bin/env bash

# This script starts a simple network with only one genesis account who is also a validator

APP_LOG_LEVEL=${APP_LOG_LEVEL:-"error"}

####

rm -rf $APP_HOME

coins="10000000000$DENOM,100000000000samoleans"
coinsV="5000000000$DENOM"


# not needed - was generated using ./build/simd testnet
$APP keys add validator
$APP keys add user

$APP init $CHAINID --chain-id $CHAINID
# change the native coin
sed -i "s/stake/$DENOM/g" $APP_HOME/config/genesis.json

$APP add-genesis-account  $($APP keys show -a validator)  $coins
$APP gentx validator $coinsV --chain-id $CHAINID
$APP collect-gentxs

# --api.enable=true ---> enable REST
$APP start --log_level $APP_LOG_LEVEL --api.enable=true
