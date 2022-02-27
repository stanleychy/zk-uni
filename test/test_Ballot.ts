import { expect } from "chai";
import { ethers } from "hardhat";

describe("Ballot", function () {
  const proposals = ["A", "B", "C"];
  const proposalsByte32 = proposals.map(ethers.utils.formatBytes32String);
  const voters = [
    "0x8626f6940e2eb28930efb4cef49b2d1f2c9c1199",
    "0xdd2fd4581271e230360230f9337d5c0430bf44c0",
    "0xbda5747bfd65f08deb54cb465eb87d40e51b197e",
    "0x2546bcd3c84621e976d8185a91a922ae77ecec30",
    "0xcd3b766ccdd6ae721141f452c550ca635964ce71",
    "0xdf3e18d64bc6a983f673ab319ccae4f1a57c7097",
    "0x1cbd3b2770909d4e10f157cabc84c7264073c9ec",
    "0xfabb0ac9d68b0b445fb7357272ff202c5651694a",
    "0x71be63f3384f5fb98995898a86b02fb2426c5788",
    "0xbcd4042de499d14e55001ccbb24a551f3b954096"
  ]

  it("Should return the first proposal as winner if tied", async function () {
    const Ballot = await ethers.getContractFactory("Ballot");
    const ballot = await Ballot.deploy(proposalsByte32);
    await ballot.deployed();

    expect(await ballot.winnerName()).to.equal(
      ethers.utils.formatBytes32String(proposals[0])
    );
  });

  it("Should be able to give 10 voters the right to vote", async function () {
    const Ballot = await ethers.getContractFactory("Ballot");
    const ballot = await Ballot.deploy(proposalsByte32);
    await ballot.deployed();

    voters.forEach(async (voter) => {
      await ballot.giveRightToVoteSingle(voter);
    });
  });

  it("Should be able to batch giveRightToVote", async function () {
    const Ballot = await ethers.getContractFactory("Ballot");
    const ballot = await Ballot.deploy(proposalsByte32);
    await ballot.deployed();

    await ballot.giveRightToVote(voters);
  });
});
