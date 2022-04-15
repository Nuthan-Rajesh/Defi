const Tether = artifacts.require("Tether");
const RWD = artifacts.require("RWD");
const DecentralBank = artifacts.require("DecentralBank");
module.exports = async function(deployer, network, accounts) {
  //Deploy mock tether contract
  await deployer.deploy(Tether);
  const tether = await Tether.deployed();

  //Deploy mock RWD contract
  // Deploy RWD Token
  await deployer.deploy(RWD);
  const rwd = await RWD.deployed();

  //Deploy mock DecentralBank contract
  // Deploy DecentralBank
  await deployer.deploy(DecentralBank, rwd.address, tether.address);
  const decentralBank = await DecentralBank.deployed();

  //We want to move all our rwd tokens to our central bank
  //Transfer tether tokens form our investor to our Decentral bank
  //1 million tokens

  // Transfer all tokens to DecentralBank (1 million)
  await rwd.transfer(decentralBank.address, "1000000000000000000000000");

  //We also want to distribute 100 tether tokens to our investors
  //automatically when they come to our app
  //Here we are transferring to the account of the investor
  //For our ease we have considered the first address to be our digital bank address
  //And second address the address of investor by default
  //this is because we want to remove all that sign in and firebase authentication

  // Transfer 100 Mock Tether tokens to investor
  await tether.transfer(accounts[1], "100000000000000000000"); //2nd account so [1] and then amount
};
