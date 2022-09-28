#!/bin/bash
sudo apt-get update
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo apt -y install docker-compose

sudo service docker start
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn
sudo apt-get install -y jq
sudo git clone https://github.com/graphprotocol/graph-node.git
sudo mv graph-node /home/ubuntu
sudo chmod 777 /home/ubuntu/graph-node/docker/docker-compose.yml
sudo sed -i 's#http://host.docker.internal:8545#<ETHEREUM-RPC-URL>#g' /home/ubuntu/graph-node/docker/docker-compose.yml
sudo chmod 777 /home/ubuntu/graph-node/docker/build.sh
sudo chmod 777 /home/ubuntu/graph-node/docker/setup.sh
cd /home/ubuntu/graph-node/docker
sudo ./build.sh
sudo ./setup.sh

sudo docker-compose up -d

sudo git clone https://github.com/graphprotocol/example-subgraph.git
sudo mv example-subgraph /home/ubuntu 
cd /home/ubuntu/example-subgraph
sudo yarn
sudo yarn codegen
sudo yarn create-local
sudo yarn deploy-local #run this command manually after deploying node in case of errors in example-subgraph directory






