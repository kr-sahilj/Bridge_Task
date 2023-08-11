const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");


const isFreshDeploy = true;
async function main() {

  if(isFreshDeploy){
    const custodyContractETH = await ethers.getContractFactory("CustodyContractETH");
    const _nftContractAddress = "0xf3FC48840673Ed92Cf2bf8e253d86eD1723E5544";
    const custodyContractETHInst = await upgrades.deployProxy(custodyContractETH, [ _nftContractAddress], { initializer: 'initialize(address)' });
    await custodyContractETHInst.deployed();

    console.log("custodyContractETH deployed to:", custodyContractETHInst.address);
  }
  else{
    const custodyContractETH = await ethers.getContractFactory("CustodyContractETH");
    const custodyContractETHAddress="";
    const custodyContractETHInst = await upgrades.upgradeProxy(custodyContractETHAddress, custodyContractETH);
    console.log("custodyContract updated to:", custodyContractETHInst.address);
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
