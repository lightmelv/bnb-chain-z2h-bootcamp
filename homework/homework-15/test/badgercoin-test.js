const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("BadgerCoin", function() {
  let badgerCoin;

  beforeEach(async function() {
    const BadgerCoin = await ethers.getContractFactory("BadgerCoin");
    badgerCoin = await BadgerCoin.deploy();
    await badgerCoin.deployed();
  });

  it("should deploy and mint initial supply of tokens", async function() {
    const name = await badgerCoin.name();
    const symbol = await badgerCoin.symbol();
    const totalSupply = await badgerCoin.totalSupply();
    const ownerBalance = await badgerCoin.balanceOf(await ethers.getSigners()[0].address);

    expect(name).to.equal("BadgerCoin");
    expect(symbol).to.equal("BC");
    expect(totalSupply).to.equal(ethers.utils.parseEther("1000000"));
    expect(ownerBalance).to.equal(ethers.utils.parseEther("1000000"));
  });

  it("should pause and unpause contract", async function() {
    // Check that the contract is not paused initially
    expect(await badgerCoin.paused()).to.equal(false);

    // Pause the contract and check that it's paused
    await badgerCoin.pause();
    expect(await badgerCoin.paused()).to.equal(true);

    // Unpause the contract and check that it's not paused
    await badgerCoin.unpause();
    expect(await badgerCoin.paused()).to.equal(false);
  });

  it("should transfer tokens between accounts", async function() {
    const [owner, account1, account2] = await ethers.getSigners();

    // Mint some tokens to the first account
    const amount1 = ethers.utils.parseEther("1000");
    await badgerCoin.transfer(account1.address, amount1);

    // Check that the balance of account1 is correct
    expect(await badgerCoin.balanceOf(account1.address)).to.equal(amount1);

    // Transfer tokens from account1 to account2
    const amount2 = ethers.utils.parseEther("500");
    await badgerCoin.connect(account1).transfer(account2.address, amount2);

    // Check that the balance of account2 is correct
    expect(await badgerCoin.balanceOf(account2.address)).to.equal(amount2);
  });

  it("should transfer tokens using allowance", async function() {
    const [owner, account1, account2] = await ethers.getSigners();

    // Mint some tokens to the first account
    const amount1 = ethers.utils.parseEther("1000");
    await badgerCoin.transfer(account1.address, amount1);

    // Approve account2 to spend tokens from account1
    const amount2 = ethers.utils.parseEther("500");
    await badgerCoin.connect(account1).approve(account2.address, amount2);

    // Transfer tokens from account1 to account2 using allowance
    await badgerCoin.connect(account2).transferFrom(account1.address, account2.address, amount2);

    // Check that the balance of account2 is correct
    expect(await badgerCoin.balanceOf(account2.address)).to.equal(amount2);
  });
});
