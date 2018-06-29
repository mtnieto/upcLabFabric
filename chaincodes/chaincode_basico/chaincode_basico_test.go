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
	"testing"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

func checkInit(t *testing.T, stub *shim.MockStub, args [][]byte) {
	res := stub.MockInit("1", args)
	if res.Status != shim.OK {
		fmt.Println("Init failed", string(res.Message))
		t.FailNow()
	}
}

func checkLeer(t *testing.T, stub *shim.MockStub, name string, value string) {
	res := stub.MockInvoke("1", [][]byte{[]byte("leer"), []byte(name)})
	if res.Status != shim.OK {
		fmt.Println("Query", name, "failed", string(res.Message))
		t.FailNow()
	}
	if res.Payload == nil {
		fmt.Println("Query", name, "failed to get value")
		t.FailNow()
	}
	if string(res.Payload) != value {
		fmt.Println("Query value", name, "was not", value, "as expected")
		t.FailNow()
	}
}

func checkLeerFail(t *testing.T, stub *shim.MockStub, name string) {
	res := stub.MockInvoke("1", [][]byte{[]byte("leer"), []byte(name)})
	if res.Status != shim.OK {
		fmt.Println("Query", name, "failed", string(res.Message))
		t.FailNow()
	}
	if res.Payload == nil {
		fmt.Println("Query", name, "failed to get value")
		t.FailNow()
	}

}

func checkGuardar(t *testing.T, stub *shim.MockStub, args [][]byte) {
	res := stub.MockInvoke("1", args)
	if res.Status != shim.OK {
		fmt.Println("Invoke", args, "failed", string(res.Message))
		t.FailNow()
	}
}

func TestExample02_Query(t *testing.T) {
	scc := new(SimpleChaincode)
	stub := shim.NewMockStub("ex02", scc)
	checkInit(t, stub, [][]byte{[]byte("init")})
	checkGuardar(t, stub, [][]byte{[]byte("guardar"), []byte("A"), []byte("345")})
	// Query A
	checkLeerFail(t, stub, "A")
	checkGuardar(t, stub, [][]byte{[]byte("guardar"), []byte("B"), []byte("456")})
	// Query B
	checkLeer(t, stub, "B", "456")
}
