import { ethers } from "hardhat";

async function main() {
  // await hre.run('compile');

  // We get the contract to deploy
  const HelloWorld = await ethers.getContractFactory("HelloWorld");
  const helloWorld = await HelloWorld.deploy();

  await helloWorld.deployed();

  console.log("HelloWorld deployed to:", helloWorld.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
