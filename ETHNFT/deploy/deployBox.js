const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = false;
async function main() {

  if(isFreshDeploy){
    const Box = await ethers.getContractFactory("BoxV3");
    const box = await upgrades.deployProxy(Box, [42]);
    await box.deployed();

    console.log("Box deployed to:", box.address);
  }
  
  else{
    const BoxContract = await ethers.getContractFactory("BoxV2");
    const BoxAddress="0x6cb49AB724df2066D57c51b641d4B39885C09dBf";
    const BoxInst = await upgrades.upgradeProxy(BoxAddress, BoxContract);
    console.log("Box updated to:", BoxInst.address);

}
  
}

// We recommend this pattern to be able to use async/awarecordOwnerit everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
