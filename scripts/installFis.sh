ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/upc.edu/orderers/orderer.upc.edu/msp/tlscacerts/tlsca.upc.edu-cert.pem
CORE_PEER_LOCALMSPID="fisMSP"
CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/fis.upc.edu/peers/peer0.fis.upc.edu/tls/ca.crt
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/fis.upc.edu/users/Admin@fis.upc.edu/msp
CORE_PEER_ADDRESS=peer0.fis.upc.edu:7051
CHANNEL_NAME=channelgeneral
CORE_PEER_TLS_ENABLED=true
peer chaincode install -n mycontract -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 >&log.txt
cat log.txt