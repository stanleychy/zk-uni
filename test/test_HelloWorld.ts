import { expect } from "chai";
import { ethers } from "hardhat";

describe("HelloWorld", function () {
  it("Should return 0 if nothing stored", async function () {
    const HelloWorld = await ethers.getContractFactory("HelloWorld");
    const helloWorld = await HelloWorld.deploy();
    await helloWorld.deployed();

    expect(await helloWorld.retrieve()).to.equal(0);
  });

  it("Should return stored number", async function () {
    const HelloWorld = await ethers.getContractFactory("HelloWorld");
    const helloWorld = await HelloWorld.deploy();
    await helloWorld.deployed();

    await helloWorld.store(721);

    expect(await helloWorld.retrieve()).to.equal(721);
  });
});
