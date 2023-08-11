const { ethers, upgrades } = require("hardhat");
const hre = require("hardhat");

const isFreshDeploy = true;
async function main() {

    if(isFreshDeploy) {
        const FxERC721RootTunnel = await ethers.getContractFactory('FxERC721RootTunnel');
        const _checkpointManager = "0x2890bA17EfE978480615e330ecB65333b880928e";
        const _fxRoot = "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA";
        const childAddress = "0xb1bb6173A3b4ce95244236C1e74dF291B9800580";
        const rootAddress = "0xf3FC48840673Ed92Cf2bf8e253d86eD1723E5544";
        // const _fxChild = "0xCf73231F28B7331BBe3124B907840A94851f9f11";
        // const custodyContractETH = "0x5E3C7235C746BE73369B90074B56fd0B8a1bB27A";
    
        const FxERC721RootTunnelInst = await upgrades.deployProxy(FxERC721RootTunnel, [_checkpointManager, _fxRoot, childAddress, rootAddress], { initializer: 'initialize(address,address,address,address)' });
        await FxERC721RootTunnelInst.deployed();
    
        console.log("FxERC721RootTunnel deployed to : ",FxERC721RootTunnelInst.address);
    }
    else{
        const FxERC721RootTunnel = await ethers.getContractFactory('FxERC721RootTunnel');
        const FxERC721RootTunnelAddress="0xd8E4E7131f3adB6B3eD7aBC37f2eE15Ad314bAFB";
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