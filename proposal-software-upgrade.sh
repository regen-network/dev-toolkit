#!/usr/bin/env bash

### This script assumes you are running setup.sh

PLAN_NAME=v3.0.0
UPGRADE_BLOCK_HEIGHT=`$APP status | jq ".SyncInfo.latest_block_height | tonumber | . + 22"`

## legacy:
#$APP tx gov submit-proposal software-upgrade "$PLAN_NAME" --upgrade-height $UPGRADE_BLOCK_HEIGHT --title "$PLAN_NAME" --description "$PLAN_NAME" --deposit 10000000$DENOM --from w1 --chain-id $CHAINID  -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM

## new:
jq ".messages[0].plan.height = \"$UPGRADE_BLOCK_HEIGHT\" | .messages[0].plan.name = \"$PLAN_NAME\" |  .deposit=\"$PROPOSAL_DEPOSIT\"" proposal-software-upgrade.json > tmp.json
$APP tx gov submit-proposal tmp.json \
  --from w1 --chain-id $CHAINID  -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM -b block



sleep 1
echo "\nQuery proposal"
$APP query gov proposal 1 --chain-id $CHAINID  --home $APP_HOME
echo

echo "Vote for proposal"
$APP tx gov vote 1 yes --from validator --chain-id $CHAINID -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM
$APP tx gov vote 1 yes --from w1 --chain-id $CHAINID --node $NODE -y --keyring-backend test --home $APP_HOME --fees 5000$DENOM
