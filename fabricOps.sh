#!/bin/bash

set -e

PROJECT_DIR=$PWD

ARGS_NUMBER="$#"
COMMAND="$1"

function verifyArg() {

    if [ $ARGS_NUMBER -ne 1 ]; then
        echo "Useage: networkOps.sh start | status | clean | cli | peer"
        exit 1;
    fi
}

OS_ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
FABRIC_ROOT=$GOPATH/src/github.com/hyperledger/fabric


function pullDockerImages(){
  local FABRIC_TAG="x86_64-1.1.0"
  for IMAGES in peer orderer ccenv tools ca; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:$FABRIC_TAG
      docker tag hyperledger/fabric-$IMAGES:$FABRIC_TAG hyperledger/fabric-$IMAGES
  done
}

function replacePrivateKey () {

    echo # Replace key

	ARCH=`uname -s | grep Darwin`
	if [ "$ARCH" == "Darwin" ]; then
		OPTS="-it"
	else
		OPTS="-i"
	fi

	cp docker-compose-template.yaml docker-compose.yaml

    CURRENT_DIR=$PWD
    cd crypto-config/peerOrganizations/fis.upc.edu/ca/
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yaml
    cd crypto-config/peerOrganizations/mat.upc.edu/ca/
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed $OPTS "s/CA2_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yaml
    cd crypto-config/peerOrganizations/dac.upc.edu/ca/
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed $OPTS "s/CA3_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yaml
    cd crypto-config/peerOrganizations/entel.upc.edu/ca/
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed $OPTS "s/CA4_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yaml
}

function generateCerts(){

    if [ ! -f $GOPATH/bin/cryptogen ]; then
        go get github.com/hyperledger/fabric/common/tools/cryptogen
    fi
    
    echo
	echo "##########################################################"
	echo "##### Generate certificates using cryptogen tool #########"
	echo "##########################################################"
	if [ -d ./crypto-config ]; then
		rm -rf ./crypto-config
	fi

    $GOPATH/bin/cryptogen generate --config=./crypto-config.yaml
    echo
}


function generateChannelArtifacts(){

    if [ ! -d ./channel-artifacts ]; then
		mkdir channel-artifacts
	fi

	if [ ! -f $GOPATH/bin/configtxgen ]; then
        go get github.com/hyperledger/fabric/common/tools/configtxgen
    fi

    echo
	echo "#################################################################"
	echo "### Generating channel configuration transaction 'channel.tx' ###"
	echo "#################################################################"

    $GOPATH/bin/configtxgen -profile UpcOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

    echo
	echo "#################################################################"
	echo "#######    Generating anchor peer update for fisMSP   ##########"
	echo "#################################################################"
    $GOPATH/bin/configtxgen -profile general -outputCreateChannelTx ./channel-artifacts/channelgeneral.tx -channelID "channelgeneral"
    $GOPATH/bin/configtxgen -profile canal0 -outputCreateChannelTx ./channel-artifacts/canal0.tx -channelID "canal0"
    $GOPATH/bin/configtxgen -profile canal1 -outputCreateChannelTx ./channel-artifacts/canal1.tx -channelID "canal1"

}

function startNetwork() {

    echo
    echo "================================================="
    echo "---------- Starting the network -----------------"
    echo "================================================="
    echo

    cd $PROJECT_DIR
    docker-compose -f docker-compose.yaml up -d
}

function cleanNetwork() {
    cd $PROJECT_DIR
    
    if [ -d ./channel-artifacts ]; then
            rm -rf ./channel-artifacts
    fi

    if [ -d ./crypto-config ]; then
            rm -rf ./crypto-config
    fi

    if [ -d ./tools ]; then
            rm -rf ./tools
    fi

    if [ -f ./docker-compose.yaml ]; then
        rm ./docker-compose.yaml
    fi

    if [ -f ./docker-compose.yamlt ]; then
        rm ./docker-compose.yamlt
    fi

    # This operations removes all docker containers and images regardless
    #
    docker rm -f $(docker ps -aq)
 #   docker rmi -f $(docker images -q)
    
    # This removes containers used to support the running chaincode.
    #docker rm -f $(docker ps --filter "name=dev" --filter "name=peer0.fis.upc.edu" --filter "name=cli" --filter "name=orderer.upc.edu" -q)

    # This removes only images hosting a running chaincode, and in this
    # particular case has the prefix dev-* 
    #docker rmi $(docker images | grep dev | xargs -n 1 docker images --format "{{.ID}}" | xargs -n 1 docker rmi -f)
}

function networkStatus() {
    docker ps --format "{{.Names}}: {{.Status}}" | grep '[peer0* | orderer* | cli ]' 
}

function dockerCli(){
    docker exec -it cli /bin/bash
}

# Network operations
verifyArg
case $COMMAND in
    "start")
        generateCerts
        generateChannelArtifacts
        replacePrivateKey
        pullDockerImages
        startNetwork
        ;;
    "status")
        networkStatus
        ;;
    "clean")
        cleanNetwork
        ;;
    "cli")
        dockerCli
        ;;
    *)
        echo "Useage: networkOps.sh start | status | clean | cli "
        exit 1;
esac

