const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

async function main() {
    const FxERC721Child = await hre.ethers.getContractFactory("FxERC721ChildTunnel");
    const childAddress = "";
    const rootAddress = "";
    const _fxChild = "0xCf73231F28B7331BBe3124B907840A94851f9f11";

    const FxERC721ChildTunnelInst = await upgrades.deployProxy(FxERC721Child, [childAddress, rootAddress, _fxChild], { initializer: 'initialize(address,address,address)' });
    await FxERC721ChildTunnelInst.deployed();

    console.log("FxERC721ChildTunnel deployed to : ".FxERC721ChildTunnelInst.address);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});