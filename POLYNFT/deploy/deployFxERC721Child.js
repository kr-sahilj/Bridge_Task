const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = false;
async function main() {

    if (isFreshDeploy) {
        const FxERC721Child = await ethers.getContractFactory("FxERC721ChildTunnel");

        const _childToken = "0x161B8EbD4489958675f71Ed803227402EAd118b1";
        const _rootToken = "0x99c53C63302e0f2c19FDe8792de8c77A742d43E3";
        const _fxChild = "0xCf73231F28B7331BBe3124B907840A94851f9f11";
        // const _custodyContract = "0xde6413a021Ac0590A2b8E853E8715b741204f7b9";
        // const _tokenTemplate = _childToken;

        const FxERC721ChildTunnelInst = await upgrades.deployProxy(FxERC721Child, [_childToken, _rootToken, _fxChild], { initializer: 'initialize(address,address,address)' });
        await FxERC721ChildTunnelInst.deployed();

        console.log("FxERC721ChildTunnel deployed to : ", FxERC721ChildTunnelInst.address);
    }
    else {
        const FxERC721Child = await ethers.getContractFactory("FxERC721ChildTunnel");
        const FxERC721ChildTunnelAddress="0x080695c251E1Fb56394B423C33E2d30432904246";
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