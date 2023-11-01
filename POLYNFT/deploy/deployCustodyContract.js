// const { ethers ,upgrades} = require("hardhat");
// const hre = require("hardhat");


// const isFreshDeploy = true;
// async function main() {

//   if(isFreshDeploy){
//     const custodyContract = await ethers.getContractFactory("CustodyContract");
//     const _nftContractAddress = "0xb1bb6173A3b4ce95244236C1e74dF291B9800580";
//     const custodyContractInst = await upgrades.deployProxy(custodyContract, [ _nftContractAddress], { initializer: 'initialize(address)' });
//     await custodyContractInst.deployed();

//     console.log("custodyContract deployed to:", custodyContractInst.address);
//   }
//   else{
//     const custodyContract = await ethers.getContractFactory("CustodyContract");
//     const custodyContractAddress="";
//     const custodyContractInst = await upgrades.upgradeProxy(custodyContractAddress, custodyContract);
//     console.log("custodyContract updated to:", custodyContractInst.address);
//   }

// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
