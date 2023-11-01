require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');
require('@openzeppelin/hardhat-defender');


const { API_URL, PRIVATE_KEY } = process.env;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.4",
  networks: {
    goerli: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`],
      gas: 3_500_000,
      // gasPrice: 100_000_000_000,
      maxFeePerGas: 101_000_000_000,
      maxPriorityFeePerGas: 18_000_000_000,
      timeout: 1200000,
      confirmations: 1,
      chainId: 5,
      hardfork: "london"
    }
  },
  defender: {
    apiKey: "6qrawkjw847vNrgXuLbfRAk5naprpUMU",
    apiSecret: "2dxYQQWdQ5qDFv94uuhav8iSbr2f6PbSoVDpkb4E6BkY9EMoAcPW9VUUW5dCHuNE",
  }
};
