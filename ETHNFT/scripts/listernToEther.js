// const { ethers } = require("hardhat");

const ethers = require("ethers");
const ABI = [
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "rootToken",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "childToken",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256[]",
          "name": "id",
          "type": "uint256[]"
        }
      ],
      "name": "FxWithdrawERC721",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "uint8",
          "name": "version",
          "type": "uint8"
        }
      ],
      "name": "Initialized",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "bytes",
          "name": "inputData",
          "type": "bytes"
        },
        {
          "indexed": true,
          "internalType": "bytes",
          "name": "message",
          "type": "bytes"
        }
      ],
      "name": "InputCheck",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "bytes",
          "name": "blockProof",
          "type": "bytes"
        },
        {
          "indexed": false,
          "internalType": "bytes32",
          "name": "txRoot",
          "type": "bytes32"
        },
        {
          "indexed": false,
          "internalType": "bytes32",
          "name": "receiptRoot",
          "type": "bytes32"
        },
        {
          "indexed": false,
          "internalType": "bytes",
          "name": "receiptProof",
          "type": "bytes"
        },
        {
          "indexed": true,
          "internalType": "bytes",
          "name": "message",
          "type": "bytes"
        }
      ],
      "name": "InputCheck1",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "childToken",
          "type": "address"
        }
      ],
      "name": "SetChildToken",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "rootToken",
          "type": "address"
        }
      ],
      "name": "SetRootToken",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "SEND_MESSAGE_EVENT_SIG",
      "outputs": [
        {
          "internalType": "bytes32",
          "name": "",
          "type": "bytes32"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "checkpointManager",
      "outputs": [
        {
          "internalType": "contract ICheckpointManager",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "childToken",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "fxChildTunnel",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "fxRoot",
      "outputs": [
        {
          "internalType": "contract IFxStateSender",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_checkpointManager",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_fxRoot",
          "type": "address"
        }
      ],
      "name": "initialize",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_checkpointManager",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_fxRoot",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_childToken",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "_rootToken",
          "type": "address"
        }
      ],
      "name": "initialize",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "bytes32",
          "name": "",
          "type": "bytes32"
        }
      ],
      "name": "processedExits",
      "outputs": [
        {
          "internalType": "bool",
          "name": "",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "bytes",
          "name": "inputData",
          "type": "bytes"
        }
      ],
      "name": "receiveMessage",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "renounceOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "rootToken",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_childToken",
          "type": "address"
        }
      ],
      "name": "setChildToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_fxChildTunnel",
          "type": "address"
        }
      ],
      "name": "setFxChildTunnel",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_rootToken",
          "type": "address"
        }
      ],
      "name": "setRootToken",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ]
require("dotenv").config();

async function main() {
    const contractAddress = "0x70D09fd69B46e381756Ecd5C1488f6096fbdA282";
    const provider = new ethers.providers.WebSocketProvider(process.env.API_URL);
    // console.log(provider);
    const contract = new ethers.Contract(contractAddress,ABI,provider);

    contract.on("InputCheck1",(blockProof, txRoot, receiptRoot, receiptProof, message, event) => {
        let info1 = {
            blockProof: blockProof,
            txRoot: txRoot,
            receiptRoot: receiptRoot,
            receiptProof: receiptProof,
            message: message,
            data: event,
        };
        console.log(JSON.stringify(info1, null, 4));
    });
    
    contract.on("InputCheck",(inputData, message, event) => {
        let info = {
            inputData: inputData,
            message: message,
            data: event,
        };
        console.log(JSON.stringify(info, null, 4));
    });
}

main();