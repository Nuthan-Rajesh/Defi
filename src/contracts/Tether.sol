// pragma solidity ^0.8.0;
// //Below is the code for smart contract for mock tether
// /* Setting up object as contract
// Then sending it to the tether
// Setting and running our metadata and the important information */

// //Decentralized exchanged : On a smart contract traders can trade tokens can trade tokens - from the smart contract
// //they can get the data(web front mobile)
// contract Tether {
//     string public name = "Tether";
//     string public symbol = "USDT";
//     uint256 public totalSupply = 1000000000000000000000000; //1 million tokens
//     uint8 public decimals = 18;
//     //After emitting events you can't read them in the past only for entitites outside of the blockchain - not stored as memory
//     //events have lower gas cost than storage

//     //setting up transfer and approval event and adresses
//     event Transfer(
//         address indexed _from,
//         address indexed _to,
//         uint _value
//         );
//     //These addresses are going to be indexed, because it essentially allows us to filter

//     event Approval(
//         address indexed _owner,
//         address indexed _spender,
//         uint _value
//         );
//     //Approval always has to come from the owner

//     //Now we are going to use some mapping to keep track of the balance for when we are transferring and when we are updating,
//     //It is very important to have that

//     mapping(address => uint256) public balanceOf;

//     //map into our mapping
//     mapping(address =>mapping(address => uint256)) public allowance;
//     //here we just have an mapping that we are sending an address to and then of those addresses, we are doing the same thing
//     //We are mapping and we are providing key store value for each address which will be set to our allowance
//     //This is how we are going to be able to keep track with iterations for allowance

//     constructor() public{
//         balanceOf[msg.sender] = totalSupply;
//         //This means that the supply will be the total amount of Tether
//         //And by doing that we were able to do transfers and approve to do transfers to and from and keep track of the balance in contract
//     }

//     //Logic for the function Transfer
//     function transfer(address _to, uint256 _value) public returns (bool success)
//     {
//         //transfer amount less than total amount of Tether
//         require(balanceOf[msg.sender]>= _value);

//         balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
//         //This means whatever the balance is going to be that same balance when we make a transfer minus the value of the amount we are transferring

//         //balance of receiver is going to increase
//         balanceOf[_to] = balanceOf[_to] + _value;

//         emit Transfer(msg.sender, _to, _value);
//         return true;

//     }

//     function approve(address _spender, uint256 _value) public returns (bool success){
//         allowance[msg.sender][_spender] = _value;
//         //Here we are prooving that the person who is currently connecting to the contract, ok towards the spender
//         //is going to be equal to value
//         //We are going to map through this and make sure it's equal to ther value before we can approve
//         emit Approval(msg.sender, _spender, _value);
//         return true;
//     }

//     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)
//     {

//         require(_value <=  balanceOf[_from]);

//         //We want to check to see if it is that we want to check to see that the value that we have here is
//         //less than or equal to the value of the balance of the address
//         require(_value <=  allowance[_from][msg.sender]);
//         //add the balance for transaction
//         balanceOf[_to] = balanceOf[_to] + _value;

//         //subtract the balance for transferFrom
//         balanceOf[_from] = balanceOf[_from] - _value;

//         //allowance functionality
//         allowance[msg.sender][_from] -= _value;
//         //allowance comes from the message sender and the address is from is going to be equal to the
//         //allowance of the message sender from minus the value
//         //The callers allowance from sender is reduced from the amount

//         emit Transfer(_from, _to, _value);
//         return true;

//     }
// }
// //Yield farming: You can come to application and you can take some tether and you can deposit into our bank and then you can get rewarded with a
// //reward token in exchange

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tether is ERC20, Ownable {
    constructor() ERC20("Tether", "USDT") {
        _mint(msg.sender, 1000000 * 10**decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
