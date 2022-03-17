#!/usr/bin/env bash

### This script assumes you are running setup.sh

export UPGRADE_TITLE=v3.0.0
export UPGRADE_BLOCK_HEIGHT=`$APP status | jq ".SyncInfo.latest_block_height | tonumber | . + 20"`
$APP tx gov submit-proposal software-upgrade "$UPGRADE_TITLE" --upgrade-height $UPGRADE_BLOCK_HEIGHT --title "$UPGRADE_TITLE" --description "$UPGRADE_TITLE" --deposit 10000000$DENOM --from w1 --chain-id $CHAINID  -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM

sleep 2
echo "\nQuery proposal"
$APP query gov proposal 1 --chain-id $CHAINID  --home $APP_HOME
echo

echo "Vote for proposal"
$APP tx gov vote 1 yes --from validator --chain-id $CHAINID -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM
$APP tx gov vote 1 yes --from w3 --chain-id $CHAINID --node $NODE -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM
