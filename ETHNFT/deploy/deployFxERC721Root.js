const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = true;
async function main() {

    if(isFreshDeploy){
        const FxERC721RootTunnel = await ethers.getContractFactory('FxERC721RootTunnel');
        const _checkpointManager = "0x2890bA17EfE978480615e330ecB65333b880928e";
        const _fxRoot = "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA";
        const childAddress = "0x42Bb3C95Bc94e3507c83dDaAD9F18128430E42e4";
        const rootAddress = "0x53859d2Eed1edf843856Be79D7419Cbad77D64C8";
    
        const FxERC721RootTunnelInst = await upgrades.deployProxy(FxERC721RootTunnel, [_checkpointManager, _fxRoot, childAddress, rootAddress], { initializer: 'initialize(address,address,address,address)' });
        await FxERC721RootTunnelInst.deployed();
    
        console.log("FxERC721RootTunnel deployed to : ",FxERC721RootTunnelInst.address);
    }
    else{
        const FxERC721RootTunnel = await ethers.getContractFactory('FxERC721RootTunnel');
        const FxERC721RootTunnelAddress="";
        const FxERC721RootTunnelInst = await upgrades.upgradeProxy(FxERC721RootTunnelAddress, FxERC721RootTunnel);
        console.log("FxERC721RootTunnel updated to:", FxERC721RootTunnelInst.address);
    }
    
}

// We recommend this pattern to be able to use async/awarecordOwnerit everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});