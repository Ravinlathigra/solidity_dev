
// SPDX-License-Identifier: MIT


//This script allows us to create and interact with a contact from another one.
pragma solidity ^0.6.0;

import "./SimpleStorage.sol";  //Import the functions we want from simple storage

contract StorageFactory is SimpleStorage{ //Inherit from SimpleStorage, you pass the name of the contract not the file name.
    
    SimpleStorage[] public simpleStorageArray; //Define a dynamic array object which is public and can be viewed as simpleStorageArray

    //any variables leveraged in script must have their type defined by preceeding the variable with the type.  For native sol types, we can just say uint256 var_name, but for objects we import from other files we must pass the Contract Name as the type. 
    
    function createSimpleStorageContract() public {  //Create a function  which requires no inout and is available to other modules and other functions within the contract.  This appends an instance of a simple storage contact to
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }
    
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        // Address 
        // ABI 
        //this line has an explicit cast to the address type and initializes a new SimpleStorage object from the address
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);  //if we were to assign this to a variable we would need to preceed the variable declaration with SimpleStorage to enforce the type.

        //this line simply gets the SimpleStorage object at the index _simpleStorageIndex in the array simpleStorageArray
        //simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }
    
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {  //vi
        //this line has an explicit cast to the address type and initializes a new SimpleStorage object from the address 
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve(); 

        //this line simply gets the SimpleStorage object at the index _simpleStorageIndex in the array simpleStorageArray
        //return simpleStorageArray[_simpleStorageIndex].retrieve(); 
    }

    function test(uint _test) public pure returns (uint256){ //dummy func, to show that pure creates a view.
        return _test*2;
    }
}