// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {PolyNft} from "./PolyNft.sol";
import {FxBaseChildTunnel} from "./FxBaseChildTunnel.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract FxERC721ChildTunnel is OwnableUpgradeable,FxBaseChildTunnel {
    address public childToken;
    address public rootToken;

    // bool 
    bool public bridgeState;


    
    //events
    event SetChildToken(address childToken);
    event SetRootToken(address rootToken);
    event Withdraw(address rootToken, address childToken, address receiver,uint256[] tokenId, uint256[] expiry);

    //modifier
    modifier bridgeEnabled {
        require(
            bridgeState,
            "bridgeWorking: bridge is not in working state"
        );
        _;
    }

    function initialize(
        address _childToken, 
        address _rootToken, 
        address _fxChild) 
        external initializer {
            __FxERC721ChildTunnel_init(_childToken, _rootToken, _fxChild);
    } 

    function __FxERC721ChildTunnel_init(address _childToken, address _rootToken, address _fxChild) internal initializer {
        __Ownable_init_unchained();
        __FxBaseChildTunnel_init(_fxChild);
        childToken = _childToken;
        rootToken = _rootToken;
    }

    // bytes32 public constant MAP_TOKEN = keccak256("MAP_TOKEN");

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
    
    function setBridgeState(bool _bridgeState) external onlyOwner {
        bridgeState = _bridgeState;
    }


    function withdraw(
        uint256[] memory tokenId
    ) external bridgeEnabled{
        
        _withdraw(msg.sender, tokenId);
    }

    function _processMessageFromRoot(
        uint256, /* stateId */
        address sender,
        bytes memory data
    ) internal virtual override validateSender(sender) {
        // decode incoming data
        // (bytes32 syncType, bytes memory syncData) = abi.decode(data, (bytes32, bytes));

        // if (syncType == MAP_TOKEN) {
        //     _mapToken(syncData);
        // } else {
        //     revert("FxERC721ChildTunnel: INVALID_SYNC_TYPE");
        // }
    }

    // function _mapToken(bytes memory syncData) internal returns (address) {
    //     (address rootToken, string memory name, string memory symbol) = abi.decode(syncData, (address, string, string));

    //     // check if it's already mapped
    //     require(childToken == address(0x0), "FxERC721ChildTunnel: ALREADY_MAPPED");
        
    //     emit TokenMapped(rootToken, childToken);

    //     // return new child token
    //     return childToken;
    // }



    function _withdraw(
        address receiver,
        uint256[] memory tokenId
    ) internal {

        uint256[] memory expiries = new uint256[](tokenId.length);
        PolyNft childTokenContract = PolyNft(childToken);

        // validate root and child token address
        require(
            childToken != address(0x0) && rootToken != address(0x0),
            "FxERC721ChildTunnel: Should have proper addresses"
        );
        
        for(uint256 i = 0; i < tokenId.length; i++)
        {
            require(msg.sender == childTokenContract.ownerOf(tokenId[i]));

            // withdraw tokens
            expiries[i] = childTokenContract.nameExpires(tokenId[i]);

            require(expiries[i]>=block.timestamp,"Domain is expired");
        }

        for(uint256 i = 0; i < tokenId.length; i++)
        {
            childTokenContract.burnToken(tokenId[i]);
        }
        
        // send message to root regarding token burn
        _sendMessageToRoot(abi.encode(rootToken, childToken, receiver, tokenId, expiries));
        emit Withdraw(rootToken, childToken, receiver, tokenId, expiries);
    }
    

    
}

