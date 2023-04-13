const { use } = require("@maticnetwork/maticjs");
const { Web3ClientPlugin } = require("@maticnetwork/maticjs-web3");
const { FxPortalClient } = require("@fxportal/maticjs-fxportal");
require("dotenv").config();
const HDWalletProvider = require("@truffle/hdwallet-provider");

// add Web3Plugin
const { API_URL, PRIVATE_KEY } = process.env;
use(Web3ClientPlugin);

const fxPortalClient = new FxPortalClient();

await fxPortalClient.init({
    network: 'testnet',
    version: 'mumbai',
    parent: {
        provider: new HDWalletProvider(PRIVATE_KEY, API_URL),
        defaultConfig: {
            from
        }
    },
    child: {
        provider: new HDWalletProvider(privateKey, childRPC),
        defaultConfig: {
            from
        }
    }
});