// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {PolyNft} from "./PolyNft.sol";

contract FxERC721ChildTunnel {

    //events
    event MessageSent(bytes message);

    function withdraw(
        address childToken,
        uint256 tokenId,
        address rootToken
    ) external {
        _withdraw(childToken,rootToken, msg.sender, tokenId);
    }


    function _withdraw(
        address childToken,
        address rootToken,
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
    function _sendMessageToRoot(bytes memory message) internal {
        emit MessageSent(message);
    }
}

