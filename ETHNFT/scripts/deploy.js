const { ethers ,upgrades} = require("hardhat");
// const hre = require("hardhat");

async function main() {

  const NftContract = await ethers.getContractFactory("ETHNFT");
  const contractInst = await upgrades.deployProxy(NftContract);
  await contractInst.deployed();
  
  console.log("ETHNFT deployed to:", contractInst.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});