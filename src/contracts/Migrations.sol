// pragma solidity ^0.8.0;

// contract Migrations {
//     address public owner;
//     //Here we are ssetting up our smart contracts, so we are setting up an address,
//     //we are making a public meaning that it has access here outside of the contract itself,
//     // if we want and we are sending this to owner
//     uint public last_completed_migration;

//     //having the constructor set up means we can do new instances to it so we can set this up as an object now by 
//     //having it in our constructor
//     constructor() public {
//         owner = msg.sender;
//         //msg.sender is the current person who is doing a call with solidityW
//         //It's the person who is currently connecting with the contract and we want to be the owner 
//     }
//     //modifier fucntions : they can modify the functions
//     modifier restricted(){
//         if(msg.sender == owner)_;
//         //if msg.sender is equal to owner _ continue with the function
//     }
//     //function for completion of each contract
//     function setCompleted(uint completed) public restricted{
//         //We create a function which is set to public and add the restricted which is a modifier
//         last_completed_migration = completed;

//     }

//     //function for upgrading the contract
//     function upgrade(address new_address) public restricted{//it's going to be new address because we are upgrading everytime
//         Migrations upgraded = Migrations(new_address);

//         upgraded.setCompleted(last_completed_migration);
//     }
// }
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
