#!/usr/bin/env bash


#### Cleanup

rm -rf $APP_HOME


#### Prepare genesis

$APP init --chain-id $CHAINID $CHAINID --home $APP_HOME

sed -i 's#tcp://127.0.0.1:26657#tcp://0.0.0.0:26657#g' $APP_HOME/config/config.toml
sed -i '/timeout_commit = "5s"/c\timeout_commit = "1s"' $APP_HOME/config/config.toml
sed -i '/minimum-gas-prices =/c\minimum-gas-prices = "'"0.0025$DENOM"'"' $APP_HOME/config/app.toml

# change evidence.max_age_duration
sed -i "s/172800000000000/60000000000/g" $APP_HOME/config/genesis.json
# change gov.max_deposit_period
sed -i "s/172800s/60s/g" $APP_HOME/config/genesis.json
# change the native coin
sed -i "s/stake/$DENOM/g" $APP_HOME/config/genesis.json
sed -i 's/"voting_period": "60s"/\"voting_period": "20s"/g' $APP_HOME/config/genesis.json


### Prepare genesis accounts and validators

$APP keys add w1 --keyring-backend test --home $APP_HOME
$APP keys add w2 --keyring-backend test --home $APP_HOME
$APP keys add w3 --keyring-backend test --home $APP_HOME
$APP keys add faucet --keyring-backend test --home $APP_HOME
$APP keys add validator --keyring-backend test --home $APP_HOME

CURRENT_TIME_SECONDS=$( date +%s )
VESTING_STARTTIME=$(( $CURRENT_TIME_SECONDS + 10 ))
VESTING_ENDTIME=$(( $CURRENT_TIME_SECONDS + 10000 ))

$APP add-genesis-account w1 --keyring-backend test 1000000000000$DENOM --home $APP_HOME
$APP add-genesis-account validator --keyring-backend test 1000000000000$DENOM --home $APP_HOME
$APP add-genesis-account faucet    --keyring-backend test 1000000000000$DENOM --home $APP_HOME

$APP add-genesis-account w2 --keyring-backend test 1000000000000$DENOM --vesting-amount 100000000000$DENOM --vesting-start-time $VESTING_STARTTIME --vesting-end-time $VESTING_ENDTIME --home $APP_HOME
$APP add-genesis-account w3 --keyring-backend test 1000000000000$DENOM --vesting-amount 500000000000$DENOM --vesting-start-time $VESTING_STARTTIME --vesting-end-time $VESTING_ENDTIME --home $APP_HOME

$APP gentx validator 90000000000$DENOM --chain-id $CHAINID  --keyring-backend test --home $APP_HOME
# $APP gentx validator 10000000000$DENOM ....
$APP collect-gentxs --home $APP_HOME


##### START

echo "* starting the chain in the background*"
$APP start --home $APP_HOME  --log_level warn &


##### Set delegations
sleep 2
echo "* setting delegation *"
VAL_OPR_ADDRESS=$($APP keys show validator -a --bech val --keyring-backend test --home $APP_HOME)

$APP tx staking delegate $VAL_OPR_ADDRESS 900000000000$DENOM  --from w1 --keyring-backend test --chain-id $CHAINID  -y --home $APP_HOME --fees 5000$DENOM
$APP tx staking delegate $VAL_OPR_ADDRESS 100000000000$DENOM  --from w2 --keyring-backend test --chain-id $CHAINID --node $NODE -y --home $APP_HOME --fees 5000$DENOM

## In each command you can
## * specify node address:
# --node $NODE
## * or they keyring
# --keyring-backend test
