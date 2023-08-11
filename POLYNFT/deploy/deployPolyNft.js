const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");


const isFreshDeploy = false;
async function main() {

  if(isFreshDeploy){
    const polyNftContract = await ethers.getContractFactory("PolyNft");
    const polyNftInst = await upgrades.deployProxy(polyNftContract);
    await polyNftInst.deployed();

    console.log("POLYNFT deployed to:", polyNftInst.address);
  }
  else{
    const polyNftContract = await ethers.getContractFactory("PolyNft");
    const PolyNftAddress="0xb1bb6173A3b4ce95244236C1e74dF291B9800580";
    const polyNftInst = await upgrades.upgradeProxy(PolyNftAddress, polyNftContract);
    console.log("PolyNft updated to:", polyNftInst.address);
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
