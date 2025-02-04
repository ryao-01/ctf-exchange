FROM docker.io/library/debian:stable-slim

# install curl and other things
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
  curl \
  jq \
  git \
  npm \
  nodejs \
  ca-certificates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install foundry (run the foundry.sh script)
RUN mkdir /foundry
WORKDIR /foundry
COPY foundry.sh ./foundry.sh
RUN ./foundry.sh

RUN /root/.foundry/bin/foundryup

# Figure out how the CTF exchange runs 
# See what the addresses in the deploy script are.
# Figure out how to get env variables (or just hard code the addresses?)
# for env variables, Luis M. said to use docker-compose

RUN mkdir /ctf-exchange
COPY . /ctf-exchange
WORKDIR /ctf-exchange

# install hardhat (smart contract stuff)
RUN npm init -y
RUN npm install --save-dev hardhat

# deploy smart contracts
#RUN 

RUN ./deploy/scripts/deploy_exchange.sh local
