#!/usr/bin/env bash

# Usage message
if [ "$#" -ne 7 ]; then
  echo "Usage:"
  echo "./deploy_exchange.sh <rpc_url> <private_key> <admin> <collateral> <ctf> <proxy_factory> <safe_factory>"
  exit 1
fi

# Assign CLI arguments to named variables
RPC_URL=$1
PK=$2
ADMIN=$3
COLLATERAL=$4
CTF=$5
PROXY_FACTORY=$6
SAFE_FACTORY=$7

# Logging the deploy arguments
echo "Deploying CTF Exchange..."
echo "Deploy args:
RPC URL: $RPC_URL
Admin: $ADMIN
Collateral: $COLLATERAL
ConditionalTokensFramework: $CTF
ProxyFactory: $PROXY_FACTORY
SafeFactory: $SAFE_FACTORY
"

# Run the deployment script
OUTPUT="$(forge script ExchangeDeployment \
    --private-key $PK \
    --rpc-url $RPC_URL \
    --json \
    --broadcast \
    --with-gas-price 200000000000 \
    -s "deployExchange(address,address,address,address,address)" $ADMIN $COLLATERAL $CTF $PROXY_FACTORY $SAFE_FACTORY)"

# Extract deployed Exchange address
EXCHANGE=$(echo "$OUTPUT" | grep "{" | jq -r .returns.exchange.value)
echo "Exchange deployed: $EXCHANGE"

echo "Complete!"
