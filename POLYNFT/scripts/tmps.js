const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('https://polygon-mumbai.g.alchemy.com/v2/xjGRSTzdW-OIVcBk8l4tJl0OX9JJ1v3V'))
let encodedFunctionSignature = web3.eth.abi.encodeFunctionSignature('setAddr(bytes32,address)');
 console.log(encodedFunctionSignature);
