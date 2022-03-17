#!/usr/bin/env bash


### Change voting period
### This script assumes you are running setup.sh

## NOTE: make sure you are using the right deposit denom in the ./param-voting-period.json file

$APP tx gov submit-proposal param-change ./param-voting-period.json --from w1 --deposit 10000000$DENOM
$APP tx gov vote 1 yes --from validator --chain-id $CHAINID -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM
$APP tx gov vote 1 yes --from w3 --chain-id $CHAINID --node $NODE -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM
