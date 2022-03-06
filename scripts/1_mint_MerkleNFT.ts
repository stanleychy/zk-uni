import { ethers } from "hardhat";

async function main() {
  const MerkleNFT = await ethers.getContractFactory("MerkleNFT");
  const merkleNFT = await MerkleNFT.deploy();
  await merkleNFT.deployed();

  const [owner, addr1] = await ethers.getSigners();

  await merkleNFT.mint(owner.address);
  await merkleNFT.mint(owner.address);
  await merkleNFT.mint(owner.address);
  await merkleNFT.mint(addr1.address);
  await merkleNFT.mint(addr1.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
