import { expect } from "chai";
import { ethers } from "hardhat";

describe("MerkleNFT", function () {
  it("Should return 0 if nothing stored", async function () {
    const MerkleNFT = await ethers.getContractFactory("MerkleNFT");
    const merkleNFT = await MerkleNFT.deploy();
    await merkleNFT.deployed();

    expect(
      ethers.utils.parseBytes32String(await merkleNFT.getLeaveValue(0))
    ).to.equal("");
  });

  it("Should mint and update leaves", async function () {
    const MerkleNFT = await ethers.getContractFactory("MerkleNFT");
    const merkleNFT = await MerkleNFT.deploy();
    await merkleNFT.deployed();

    const [owner] = await ethers.getSigners();

    await merkleNFT.mint(owner.address);

    expect(await merkleNFT.getLeaveValue(0)).to.be.not.equal("");
  });

  it("Should mint and update Merkle Root", async function () {
    const MerkleNFT = await ethers.getContractFactory("MerkleNFT");
    const merkleNFT = await MerkleNFT.deploy();
    await merkleNFT.deployed();

    const [owner] = await ethers.getSigners();

    await merkleNFT.mint(owner.address);

    expect(await merkleNFT.getMerkleRoot()).to.be.not.equal("");
  });

  it("Cannot mint more than 8", async function () {
    const MerkleNFT = await ethers.getContractFactory("MerkleNFT");
    const merkleNFT = await MerkleNFT.deploy();
    await merkleNFT.deployed();

    const [owner] = await ethers.getSigners();

    for (let i = 0; i < 8; i++) {
      await merkleNFT.mint(owner.address);
    }

    await expect(merkleNFT.mint(owner.address)).to.be.revertedWith("Sold out");
  });
});
