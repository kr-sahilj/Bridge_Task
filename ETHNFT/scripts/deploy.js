const { ethers ,upgrades} = require("hardhat");
const hre = require("hardhat");

async function main() {

  const NftContract = await ethers.getContractFactory("EthNft");
  const EthNftInst = await upgrades.deployProxy(NftContract);
  await EthNftInst.deployed();
  
  console.log("EthNft deployed to:", EthNftInst.address);

  const FxERC721RootTunnel = await hre.ethers.getContractFactory('FxERC721RootTunnel');
  const _checkpointManager = "0x2890bA17EfE978480615e330ecB65333b880928e";
  const _fxRoot = "0x3d1d3E34f7fB6D26245E6640E1c50710eFFf15bA";
  const childAddress = ""; 
  const rootAddress = EthNftInst.address;

  const FxERC721RootTunnelInst = await upgrades.deployProxy(FxERC721RootTunnel,[_checkpointManager,_fxRoot,childAddress,rootAddress],{ initializer: 'initialize(address,address,address,address)' });
  await FxERC721RootTunnelInst.deploy();

  console.log("FxERC721RootTunnel deployed to : ". FxERC721RootTunnelInst.address);
}

// We recommend this pattern to be able to use async/awarecordOwnerit everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
