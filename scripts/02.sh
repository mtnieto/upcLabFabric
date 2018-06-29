#!/bin/bash
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/upc.edu/orderers/orderer.upc.edu/msp/tlscacerts/tlsca.upc.edu-cert.pem
CORE_PEER_LOCALMSPID="fisMSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/fis.upc.edu/peers/peer0.fis.upc.edu/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/fis.upc.edu/users/Admin@fis.upc.edu/msp
CORE_PEER_ADDRESS=peer0.fis.upc.edu:7051
CHANNEL_NAME=channelgeneral
CORE_PEER_TLS_ENABLED=true

echo "Join de Fis a Canal general"
peer channel join -b $CHANNEL_NAME.block  >&log.txt
cat log.txt

CORE_PEER_ADDRESS=peer1.fis.upc.edu:7051

echo "Join de Fis a Canal0"
peer channel join -b canal0.block  >&log.txt
cat log.txt


CORE_PEER_ADDRESS=peer2.fis.upc.edu:7051
echo "Join de Fis a Canal1"
peer channel join -b canal1.block  >&log.txt
cat log.txt