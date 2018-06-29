/*
Copyright IBM Corp. 2016 All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

// SimpleChaincode example simple Chaincode implementation
type SimpleChaincode struct {
}

func (t *SimpleChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("ex02 Init")

	return shim.Success(nil)
}

func (t *SimpleChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	fmt.Println("ex02 Invoke")
	function, args := stub.GetFunctionAndParameters()
	if function == "guardar" {
		// Make payment of X units from A to B
		return t.guardar(stub, args)
	} else if function == "leer" {
		// Deletes an entity from its state
		return t.leer(stub, args)

	}
	return shim.Error("Invalid invoke function name. Expecting \"invoke\" \"delete\" \"query\"")
}

// Transaction makes payment of X units from A to B
func (t *SimpleChaincode) guardar(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var clave string // Entities
	var valor string // Asset holdings
	var err error

	if len(args) != 2 {
		return shim.Error("Número incorrecto de argumentos. Esperando 2")
	}

	clave = args[0]
	valor = args[1]
	err = stub.PutState(clave, []byte(valor))
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

// query callback representing the query of a chaincode
func (t *SimpleChaincode) leer(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	var valor string // Entities
	var err error

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting name of the person to query")
	}

	valor = args[0]

	// Get the state from the ledger
	Avalbytes, err := stub.GetState(valor)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + valor + "\"}"
		return shim.Error(jsonResp)
	}

	if Avalbytes == nil {
		jsonResp := "{\"Error\":\"Nil amount for " + valor + "\"}"
		return shim.Error(jsonResp)
	}

	jsonResp := "{\"Name\":\"" + valor + "\",\"Amount\":\"" + string(Avalbytes) + "\"}"
	fmt.Printf("Query Response:%s\n", jsonResp)
	return shim.Success(Avalbytes)
}

func main() {
	err := shim.Start(new(SimpleChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}
