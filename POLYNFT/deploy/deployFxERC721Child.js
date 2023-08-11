const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = true;
async function main() {

    if (isFreshDeploy) {
        const FxERC721Child = await ethers.getContractFactory("FxERC721ChildTunnel");

        const _childToken = "0xb1bb6173A3b4ce95244236C1e74dF291B9800580";
        const _rootToken = "0xf3fc48840673ed92cf2bf8e253d86ed1723e5544";
        const _fxChild = "0xCf73231F28B7331BBe3124B907840A94851f9f11";
        // const _custodyContract = "0xde6413a021Ac0590A2b8E853E8715b741204f7b9";
        const _tokenTemplate = "0xb1bb6173A3b4ce95244236C1e74dF291B9800580";

        const FxERC721ChildTunnelInst = await upgrades.deployProxy(FxERC721Child, [_childToken, _rootToken, _fxChild, _tokenTemplate], { initializer: 'initialize(address,address,address, address)' });
        await FxERC721ChildTunnelInst.deployed();

        console.log("FxERC721ChildTunnel deployed to : ", FxERC721ChildTunnelInst.address);
    }
    else {
        const FxERC721Child = await ethers.getContractFactory("FxERC721ChildTunnel");
        const FxERC721ChildTunnelAddress="";
        const FxERC721ChildTunnelInst = await upgrades.upgradeProxy(FxERC721ChildTunnelAddress, FxERC721Child);
        console.log("FxERC721ChildTunnel updated to:", FxERC721ChildTunnelInst.address);
    }

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});