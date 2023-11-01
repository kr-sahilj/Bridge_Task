// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {EthNft} from "./EthNft.sol";
import {FxBaseRootTunnel} from "./FxBaseRootTunnel.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Create2} from "lib/Create2.sol";
import {IERC721Receiver} from "lib/IERC721Receiver.sol";

contract FxERC721RootTunnel is OwnableUpgradeable, FxBaseRootTunnel, Create2{
    address public childToken;
    address public rootToken;

    bytes32 public constant DEPOSIT = keccak256("DEPOSIT");
    bytes32 public constant MAP_TOKEN = keccak256("MAP_TOKEN");

    mapping(address => address) public rootToChildTokens;

    //events
    event FxWithdrawERC721(
        address indexed rootToken,
        address indexed childToken,
        address indexed userAddress,
        uint256[] id
    );
    
    event SetChildToken(address childToken);
    event SetRootToken(address rootToken);
    event TokenMappedERC721(address indexed rootToken, address indexed childToken);
    event FxDepositERC721(
        address indexed rootToken,
        address indexed depositor,
        address indexed userAddress,
        uint256[] id
    );

    bytes32 public childTokenTemplateCodeHash;

    function initialize(
        address _checkpointManager,
        address _fxRoot, 
        address _childToken, 
        address _rootToken) 
        external 
        initializer {
            __FxERC721RootTunnel_init(_checkpointManager, _fxRoot, _childToken, _rootToken);
    }

    function __FxERC721RootTunnel_init(
        address _checkpointManager,
        address _fxRoot, 
        address _childToken, 
        address _rootToken) 
        internal 
        initializer {
            __Ownable_init_unchained();
            __FxBaseRootTunnel_init(_checkpointManager,_fxRoot);
            childToken = _childToken;
            rootToken = _rootToken;
            childTokenTemplateCodeHash = keccak256(minimalProxyCreationCode(childToken)); 
    }

    

    //  = keccak256(minimalProxyCreationCode(rootToken));

    function setChildToken(address _childToken) external onlyOwner {
        require(_childToken != address(0),"Should be not zero");
        childToken = _childToken;
        emit SetChildToken(childToken);
    }

    function setRootToken(address _rootToken) external onlyOwner {
        require(_rootToken != address(0),"Should be not zero");
        rootToken = _rootToken;
        emit SetRootToken(rootToken);
    }
    
    

    // bytes32 public immutable childTokenTemplateCodeHash;

    // constructor(
    //     address _checkpointManager,
    //     address _fxRoot,
    //     address _fxERC721Token
    // ) FxBaseRootTunnel(_checkpointManager, _fxRoot) {
    //     // compute child token template code hash
    //     childTokenTemplateCodeHash = keccak256(minimalProxyCreationCode(_fxERC721Token));
    // }
    function mapToken(address rootToken1) public {
        // check if token is already mapped
        require(rootToChildTokens[rootToken1] == address(0x0), "FxERC721RootTunnel: ALREADY_MAPPED");

        // MAP_TOKEN, encode(rootToken, name, symbol)
        bytes memory message = abi.encode(MAP_TOKEN, abi.encode(rootToken1));
        // slither-disable-next-line reentrancy-no-eth
        _sendMessageToChild(message);

        // compute child token address before deployment using create2
        bytes32 salt = keccak256(abi.encodePacked(rootToken1));
        address childToken1 = computedCreate2Address(salt, childTokenTemplateCodeHash, fxChildTunnel);

        // add into mapped tokens
        rootToChildTokens[rootToken] = childToken1;
        emit TokenMappedERC721(rootToken, childToken1);
    }

    function deposit(address rootToken1, address user, uint256[] memory tokenId, bytes memory data) public {
        // map token if not mapped
        EthNft rootTokenContract = EthNft(rootToken1);
        uint256[] memory expiries = new uint256[](tokenId.length);
        

        for(uint256 i = 0; i < tokenId.length; i++)
        {
            require(msg.sender == rootTokenContract.ownerOf(tokenId[i]));

            // withdraw tokens
            expiries[i] = rootTokenContract.nameExpires(tokenId[i]);

            require(expiries[i]>=block.timestamp,"Domain is expired");

            // transfer from depositor to this contract
            rootTokenContract.burnToken(tokenId[i]);
        }

        // rootTokenContract.burnToken(tokenId);

        // DEPOSIT, encode(rootToken, depositor, user, tokenId, extra data)
        bytes memory message = abi.encode(DEPOSIT, abi.encode(rootToken1, msg.sender, user, tokenId, expiries, data));
        _sendMessageToChild(message);
        emit FxDepositERC721(rootToken1, msg.sender, user, tokenId);
    }

    // exit processor
    function _processMessageFromChild(bytes memory data) internal virtual override {
        (address rootTokenFromChild, address childTokenFromChild, address to, uint256[] memory tokenId, uint256[] memory expiry) = abi.decode(
            data,
            (address, address, address, uint256[] , uint256[])
        );

        // validate addressed for root to child
        require(rootTokenFromChild == rootToken,"Invalid rootToken");
        require(childTokenFromChild == childToken,"Invalid childToken");
        
        //Validate to address
        require(to != address(0),"Should be not zero");

        //validate tokenIds
        for(uint256 i = 0; i < tokenId.length; i++)
        {
            require(tokenId[i]!=0,"Invalid tokenId");
        }

        for(uint256 i = 0; i < tokenId.length; i++)
        {
            EthNft(rootToken).mintForBridge(to, tokenId[i], expiry[i]);
        }

        // transfer from tokens to
        
        
        emit FxWithdrawERC721(rootToken, childToken, to, tokenId);
        
    }
}