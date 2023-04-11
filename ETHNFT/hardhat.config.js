require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require('@openzeppelin/hardhat-upgrades');

const { API_URL, PRIVATE_KEY } = process.env;
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    goerli: {
      url: API_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  },
};
