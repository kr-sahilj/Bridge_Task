require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');

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
};
