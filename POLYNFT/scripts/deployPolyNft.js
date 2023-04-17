const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");

async function main() {

  const NftContract = await hre.ethers.getContractFactory("PolyNft");
  const polyNftInst = await upgrades.deployProxy(NftContract);
  await polyNftInst.deployed();

  console.log("POLYNFT deployed to:", polyNftInst.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
