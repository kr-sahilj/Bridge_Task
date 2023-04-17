const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = true;
async function main() {

    if (isFreshDeploy) {
        const FxERC721Child = await ethers.getContractFactory("FxERC721ChildTunnel");

        const _childToken = "0x42Bb3C95Bc94e3507c83dDaAD9F18128430E42e4";
        const _rootToken = "0x53859d2Eed1edf843856Be79D7419Cbad77D64C8";
        const _fxChild = "0xCf73231F28B7331BBe3124B907840A94851f9f11";

        const FxERC721ChildTunnelInst = await upgrades.deployProxy(FxERC721Child, [_childToken, _rootToken, _fxChild], { initializer: 'initialize(address,address,address)' });
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