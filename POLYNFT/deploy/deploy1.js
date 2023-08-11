const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");


const isFreshDeploy = true;
async function main() {

  if(isFreshDeploy){

    const _admin = "0x3bd10D495e854785ec11fa832618c6D1a50Cb4df";
    const _token = "0x2Bdd2aC5329579FE1E4110b88Cbb9c43445D13ac";
    const DecentraWebTokenLocker = await ethers.getContractFactory("DecentraWebTokenLocker");
    const DecentraWebTokenLockerInst = await upgrades.deployProxy(DecentraWebTokenLocker, [_admin, _token], { initializer: 'initialize(address,address)' });
    await DecentraWebTokenLockerInst.deployed();

    console.log("DecentraWebTokenLockerInst deployed to:", DecentraWebTokenLockerInst.address);
  }
  else{
    const DecentraWebTokenLocker = await ethers.getContractFactory("DecentraWebTokenLocker");
    const DecentraWebTokenLockerInst="";
    const DecentraWebTokenLockerInst1 = await upgrades.upgradeProxy(DecentraWebTokenLockerInst, DecentraWebTokenLocker);
    console.log("PolyNft updated to:", DecentraWebTokenLockerInst1.address);
  }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
