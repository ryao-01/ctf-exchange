#!/usr/bin/env bash

LOCAL=.env.local
TESTNET=.env.testnet
MAINNET=.env

ADMIN=0x734014f9513b483180a6D78599b6BaeC500B63a0
PK=73eeac4ceb8f325a58691d756373b26bb053daf0b1699f2a3e3168f2a7cb9d9f
COLLATERAL=
CTF=
PROXY_FACTORY=0x9028afF864393460218a78f71cdc0Fc7B6E0E109
SAFE_FACTORY=0x0C0FD2788556E5c0f10Cfd16A4abbF8BAbc851Da

RPC_URL=http://127.0.0.1:53129
# THE RPC_URL could be an issue if it dynamically changes everytime kurtosis cdk is ran. (seems to be the case)
# Might have to use env variable for it. (put in the docker-compose)
# not sure how the networking between the containers works tho

if [ -z $1 ]
then
  echo "usage: deploy_exchange.sh [local || testnet || mainnet]"
  exit 1
elif [ $1 == "local" ]
then
  ENV=$LOCAL
elif [ $1 == "testnet" ]
then
  ENV=$TESTNET
elif [ $1 == "mainnet" ]
then
  ENV=$MAINNET
else
  echo "usage: deploy_exchange.sh [local || testnet || mainnet]"
  exit 1
fi

source $ENV

echo "Deploying CTF Exchange..."

echo "Deploy args:
Admin: $ADMIN
Collateral: $COLLATERAL
ConditionalTokensFramework: $CTF
ProxyFactory: $PROXY_FACTORY
SafeFactory: $SAFE_FACTORY
"

#ERC20 Token stuff (fake USDC)
# curl json rpc call

# modified this to /root/.foundry/bin/forge
OUTPUT="$(/root/.foundry/bin/forge script ExchangeDeployment \
    --private-key $PK \
    --rpc-url $RPC_URL \
    --json \
    --broadcast \
    --with-gas-price 200000000000 \
    -s "deployExchange(address,address,address,address,address)" $ADMIN $COLLATERAL $CTF $PROXY_FACTORY $SAFE_FACTORY)"


EXCHANGE=$(echo "$OUTPUT" | grep "{" | jq -r .returns.exchange.value)
echo "Exchange deployed: $EXCHANGE"

echo "Complete!"
