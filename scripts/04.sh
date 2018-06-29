#!/bin/bash
ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/upc.edu/orderers/orderer.upc.edu/msp/tlscacerts/tlsca.upc.edu-cert.pem
CORE_PEER_LOCALMSPID="entelMSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/entel.upc.edu/peers/peer0.entel.upc.edu/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/entel.upc.edu/users/Admin@entel.upc.edu/msp
CORE_PEER_ADDRESS=peer0.entel.upc.edu:7051
CHANNEL_NAME=channelgeneral
CORE_PEER_TLS_ENABLED=true

peer channel join -b $CHANNEL_NAME.block  >&log.txt
cat log.txt

CORE_PEER_ADDRESS=peer1.entel.upc.edu:7051

echo "Join de ENTEL a Canal0"
peer channel join -b canal1.block  >&log.txt
cat log.txt