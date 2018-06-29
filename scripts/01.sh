#!/bin/bash
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/upc.edu/orderers/orderer.upc.edu/msp/tlscacerts/tlsca.upc.edu-cert.pem
CORE_PEER_LOCALMSPID="fisMSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/fis.upc.edu/peers/peer0.fis.upc.edu/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/fis.upc.edu/users/Admin@fis.upc.edu/msp
CORE_PEER_ADDRESS=peer0.fis.upc.edu:7051
CHANNEL_NAME=channelgeneral
CORE_PEER_TLS_ENABLED=true
echo "GENERANDO CANAL GENERAL"
peer channel create -o orderer.upc.edu:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channelgeneral.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
cat log.txt
echo "GENERANDO CANAL0"

peer channel create -o orderer.upc.edu:7050 -c canal0 -f ./channel-artifacts/canal0.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
cat log.txt
echo "GENERANDO CANAL1"

peer channel create -o orderer.upc.edu:7050 -c canal1 -f ./channel-artifacts/canal1.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
cat log.txt