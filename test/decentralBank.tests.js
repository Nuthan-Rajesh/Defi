/* Mocha is a feature-rich JavaScript test framework running on Node.js and in the browser, making asynchronous testing simple and fun. 
Mocha tests run serially, allowing for flexible and accurate reporting, while mapping uncaught exceptions to the correct test cases. Hosted on GitHub. */

//Chai is a BDD / TDD assertion library for node and the browser that can be delightfully paired with any javascript testing framework.
const Tether = artifacts.require("Tether");
const RWD = artifacts.require("RWD");
const DecentralBank = artifacts.require("DecentralBank");

require("chai")
  .use(require("chai-as-promised"))
  .should();

contract("DecentralBank", ([owner, customer]) => {
  //All the code for testing goes here

  //Setting up all required variables at the top
  let tether, rwd, decentralBank;

  //helper function to convert to wei
  function tokens(number) {
    return web3.utils.toWei(number, "ether");
  }

  //before will run any code beforehand that we will run for tests
  before(async () => {
    //Load Contracts
    tether = await Tether.new();
    rwd = await RWD.new();
    decentralBank = await DecentralBank.new(rwd.address, tether.address);

    console.log("Bank address:", decentralBank.address);
    console.log("Rwd address:", rwd.address);
    console.log("Tether address:", tether.address);

    //Transfer all tokens to DecentralBank (1 million)
    await rwd.transfer(decentralBank.address, tokens("1000000"));

    //Transfer 100 mock Tethers to Customer
    await tether.transfer(customer, tokens("100"), { from: owner });
  });

  //1st test to check if we have successful name matching in contracts
  describe("Mock Tether Deployment", async () => {
    it("matches name successfully", async () => {
      const name = await tether.name();
      assert.equal(name, "Tether");
    });
  });

  describe("RWD Token Deployment", async () => {
    it("matches name successfully", async () => {
      const name = await rwd.name();
      assert.equal(name, "Reward Token");
    });
  });

  describe("Decentral Bank Deployment", async () => {
    it("matches name successfully", async () => {
      const name = await decentralBank.name();
      assert.equal(name, "Decentral Bank");
    });

    //Logic for decentral bank having the tokens
    it("Contract has tokens", async () => {
      //we are going to await the  balance of our rewards in the decentral bank address
      let balance = await rwd.balanceOf(decentralBank.address);
      assert.equal(balance, tokens("1000000"));
    });

    describe("Yield Farming", async () => {
      it("rewards tokens for staking", async () => {
        const delay = (ms) => new Promise((res) => setTimeout(res, ms));

        let result;
        //Check Investor Balance
        result = await tether.balanceOf(customer);
        assert.equal(
          result.toString(),
          tokens("100"),
          "customer mock wallet balance before staking"
        );

        // Approve the decentral bank's tether
        await tether.increaseAllowance(decentralBank.address, tokens("100"), {
          from: customer,
        });

        console.log("depositing");

        await decentralBank.depositTokens(tokens("100"), {
          from: customer,
        });

        // Check updated Balance of Customer
        result = await tether.balanceOf(customer);
        assert.equal(
          result.toString(),
          tokens("0"),
          "customer mock wallet balance after staking"
        );

        //Check updated balance of decentralBank
        result = await tether.balanceOf(decentralBank.address);
        assert.equal(
          result.toString(),
          tokens("100"),
          "decentral bank mock wallet balance after staking from customer"
        );

        //Is staking Update
        result = await decentralBank.isStaking(customer);
        assert.equal(
          result.toString(),
          "true",
          "customer staking status to be true"
        );

        // Issue Tokens
        await decentralBank.issueTokens({from: owner});

        // Ensure only owner can issue tokens
        await decentralBank.issueTokens({from: customer}).should.be.rejected;

        // Unstaking Tokens
        await decentralBank.unstakeTokens({from: customer});

        // Check updated Balance of Customer after unstaking
        result = await tether.balanceOf(customer);
        assert.equal(
          result.toString(),
          tokens("100"),
          "customer mock wallet balance after unstaking"
        );

        //Check updated balance of decentralBank
        result = await tether.balanceOf(decentralBank.address);
        assert.equal(
          result.toString(),
          tokens("0"),
          "decentral bank mock wallet balance after staking from customer"
        );

        //Is staking Balance
        result = await decentralBank.isStaking(customer);
        assert.equal(
          result.toString(),
          "false",
          "customer is no longer staking after staking"
        );

      });
    });
  });
});
