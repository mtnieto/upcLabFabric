# Configurando una red de Hyperledger Fabric #

El esqueleto para trabajar sobre el está en el siguiente repo:

https://github.com/mtnieto/hf-template

## Files ##
Para crear la red tenemos que modificar los siguientes archivos

### 1. crypto-config.yaml ###

Definiremos el consorcio (upc.edu)las organizaciones (fis, mat, dac y entel) y el número de peers por organización

### 2. configtx.yaml ##

En este fichero definimos los canales y los peers que pertenecen a cada canal. Del mismo modo hay que definir los MSP (membership service providers) de los peers.

Una vez que está todo configurado, en el fabricOps.sh modificamos el siguiente método en función de nuestra infraestructura y configuración. 


### 3. fabricOps.sh ##
generateChannelArtifacts: Modify the following command lines

```
$GOPATH/bin/configtxgen -profile UpcOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

$GOPATH/bin/configtxgen -profile genesis -outputCreateChannelTx ./channel-artifacts/channelgenesis.tx -channelID "channelgenesis"

```

Cuidado con el --channelID que solo recibe minúsuclas!
Del último comando lo replicamos tantas veces como canales tengamos
Ejecutamos el script ./fabricOps.sh start comentando todos los métodos del argumento start menos los dos primeros: generateCerts y generateChannelArtifacts.

### 4. base/docker-compose-base.yaml ###
Modificamos los paths de los certificados en función del peer. No olvidar cambiar el mapeo de los puertos para que no coincidan.

### 5. docker-compose-template.yaml
Mismo que paso 4

### 6. fabricOps.sh ###
Modificamos el método replacePrivateKey:
Se cambian los paths de los  certificados


## Ejecutar la red ##


```
./fabricOps.sh start
```

## Creación del canal y join de los peers ##

Ejecutamos los siguientes comandos:

```
./fabricOps.sh cli // nos metemos en el contenedor cli
./script/01.sh
./script/02.sh
./script/03.sh
./script/04.sh
./script/05.sh
```



## Configurar el entorno para desplegar el chaincode ##

Despues de ejecutar todos los scripts se realiza un:
```
docker network ls
```

Con el nombre de la red en la que se encuentran los docker modificamos el fichero /base/peer-base.yaml.



```
- CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=upclabfabric_default

```

Reiniciamos la red para visualizar los cambios

````
./fabricOps.sh start

````