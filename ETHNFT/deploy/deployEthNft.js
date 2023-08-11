const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = false;
async function main() {

  if(isFreshDeploy){
    const NftContract = await ethers.getContractFactory("EthNft");
    const EthNftInst = await upgrades.deployProxy(NftContract);
    await EthNftInst.deployed();

    console.log("EthNft deployed to:", EthNftInst.address);
  }
  
  else{
    const NftContract = await ethers.getContractFactory("EthNft");
    const EthNftAddress="0xf3FC48840673Ed92Cf2bf8e253d86eD1723E5544";
    const EthNftInst = await upgrades.upgradeProxy(EthNftAddress, NftContract);
    console.log("EthNft updated to:", EthNftInst.address);
  }
  
}

// We recommend this pattern to be able to use async/awarecordOwnerit everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
