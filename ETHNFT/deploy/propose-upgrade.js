// scripts/propose-upgrade.js
// const { AdminClient } = require('@openzeppelin/defender-admin-client');
// const client = new AdminClient({ apiKey: "6qrawkjw847vNrgXuLbfRAk5naprpUMU", apiSecret: "2dxYQQWdQ5qDFv94uuhav8iSbr2f6PbSoVDpkb4E6BkY9EMoAcPW9VUUW5dCHuNE" });
const  {ethers, upgrades, defender }  = require('hardhat');

async function main() {
  const proxyAddress = '0x6cb49AB724df2066D57c51b641d4B39885C09dBf';

  // const newImplementation = '0xd75884C8e01bf623765e519df684080Dc3bD502B';
  // const via = '0xf41F0a5F0c323Fe4219f743cbcdb900db259aa5D';
  // const viaType = 'Gnosis Safe';
  // const newImplementationAbi ="[{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint8\",\"name\":\"version\",\"type\":\"uint8\"}],\"name\":\"Initialized\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"newValue\",\"type\":\"uint256\"}],\"name\":\"ValueChanged\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"decrement\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"increment\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"initialValue\",\"type\":\"uint256\"}],\"name\":\"initialize\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"retrieve\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"newValue\",\"type\":\"uint256\"}],\"name\":\"store\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"version\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"pure\",\"type\":\"function\"}]";
  // const contract = { network: 'goerli', address: proxyAddress };
  // const proposal = await client.proposeUpgrade({ newImplementation, newImplementationAbi , via, viaType}, contract);
  // // console.log("Preparing proposal...");
  // // const proposal = await client.proposeUpgrade(proxyAddress, Box, { title: 'Upgrade to v3' });
  // console.log("Upgrade proposal created at:", proposal.url);

  const BoxV3 = await ethers.getContractFactory("BoxV3");
  const proposal = await defender.proposeUpgrade(proxyAddress, BoxV3);
  console.log("Upgrade proposal created at:", proposal.url);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  })
