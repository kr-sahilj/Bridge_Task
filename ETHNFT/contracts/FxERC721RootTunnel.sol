// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {EthNft} from "./EthNft.sol";
import {FxBaseRootTunnel} from "./FxBaseRootTunnel.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract FxERC721RootTunnel is OwnableUpgradeable, FxBaseRootTunnel{
    address public childToken;
    address public rootToken;
    
    //events
    event FxWithdrawERC721(
        address indexed rootToken,
        address indexed childToken,
        address indexed userAddress,
        uint256 id
    );
    event SetChildToken(address childToken);
    event SetRootToken(address rootToken);
    
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
    }

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
    

    // exit processor
    function _processMessageFromChild(bytes memory data) internal virtual override {
        (address rootTokenFromChild, address childTokenFromChild, address to, uint256 tokenId, uint256 expiry) = abi.decode(
            data,
            (address, address, address, uint256, uint256)
        );

        // validate addressed for root to child
        require(rootTokenFromChild == rootToken,"Invalid rootToken");
        require(childTokenFromChild == childToken,"Invalid childToken");
        
        //Validate to address
        require(to != address(0),"Should be not zero");

        //validate tokenId
        require(tokenId!=0,"Invalid tokenId");


        // transfer from tokens to
        
        EthNft(rootToken).mintForBridge(to, tokenId, expiry);
        emit FxWithdrawERC721(rootToken, childToken, to, tokenId);
    }
}