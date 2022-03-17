#!/usr/bin/env bash

# This script starts a simple network with only one genesis account who is also a validator

rm -rf ~/.simapp

coins="10000000000$DENOM,100000000000samoleans"
coinsV="5000000000$DENOM"


# not needed - was generated using ./build/simd testnet
$APP keys add validator

$APP init robert --chain-id $CHAINID
$APP add-genesis-account validator $coins
$APP gentx validator $coinsV --chain-id $CHAINID
$APP collect-gentxs
$APP start
