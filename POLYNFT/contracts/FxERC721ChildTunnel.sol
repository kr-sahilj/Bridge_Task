// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {PolyNft} from "./PolyNft.sol";
import {FxBaseChildTunnel} from "./FxBaseChildTunnel.sol";

contract FxERC721ChildTunnel is FxBaseChildTunnel, PolyNft {
    address private childToken;
    address private rootToken;

    function __FxERC721ChildTunnel_init(address _childToken, address _rootToken, address _fxChild) external initializer {
        __FxBaseChildTunnel_init(_fxChild);
        childToken = _childToken;
        rootToken = _rootToken;
    }

    // bytes32 public constant MAP_TOKEN = keccak256("MAP_TOKEN");

    function setChildToken(address _childToken) external {
        childToken = _childToken;
    }

    function setRootToken(address _rootToken) external {
        rootToken = _rootToken;
    }
    
    function withdraw(
        uint256 tokenId
    ) external {
        _withdraw(msg.sender, tokenId);
    }

    function _processMessageFromRoot(
        uint256, /* stateId */
        address sender,
        bytes memory data
    ) internal override validateSender(sender) {
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
        uint256 tokenId
    ) internal {
        PolyNft childTokenContract = PolyNft(childToken);

        // validate root and child token address
        require(
            childToken != address(0x0) && rootToken != address(0x0),
            "FxERC721ChildTunnel: Should have proper addresses"
        );

        require(msg.sender == childTokenContract.ownerOf(tokenId));

        // withdraw tokens
        uint256 expiry = childTokenContract.nameExpires(tokenId);
        childTokenContract.burnToken(tokenId);

        // send message to root regarding token burn
        _sendMessageToRoot(abi.encode(rootToken, childToken, receiver, tokenId, expiry));
    }
    
}

