const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = true;
async function main() {

    if (isFreshDeploy) {
        const TestContract = await ethers.getContractFactory("Test");
        const TestInst = await upgrades.deployProxy(TestContract);
        await TestInst.deployed();

        console.log("TestInst deployed to:", TestInst.address);
    }
    else {
        const Test = await ethers.getContractFactory("Test");
        const TestAddress="0x0002892D0da9aE001A3488E3904735794D09Dca1";
        const TestInst = await upgrades.upgradeProxy(TestAddress, Test);
        console.log("Test updated to:", TestInst.address);
    }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});