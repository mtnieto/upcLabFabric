#!/bin/bash
echo $(pwd)
echo "********...........CREATING CHANNEL...........********"
./scripts/01.sh
echo "********............JOINING PEERS...........********"
./scripts/02.sh
./scripts/03.sh
./scripts/04.sh
./scripts/05.sh

while [ 1 ]                                                                
do                                                                         
  sleep 60                                                                 
done