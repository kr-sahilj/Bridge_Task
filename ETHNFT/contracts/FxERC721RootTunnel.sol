// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {EthNft} from "./EthNft.sol";
import {FxBaseRootTunnel} from "./FxBaseRootTunnel.sol";
import {Create2} from "lib/Create2.sol";

contract FxERC721RootTunnel is FxBaseRootTunnel, Create2{
    // maybe DEPOSIT and MAP_TOKEN can be reduced to bytes4

    event TokenMappedERC721(address indexed rootToken, address indexed childToken);
    event FxWithdrawERC721(
        address indexed rootToken,
        address indexed childToken,
        address indexed userAddress,
        uint256 id
    );
    

    bytes32 public immutable childTokenTemplateCodeHash;

    constructor(
        address _checkpointManager,
        address _fxRoot,
        address _fxERC721Token
    ) FxBaseRootTunnel(_checkpointManager, _fxRoot) {
        // compute child token template code hash
        childTokenTemplateCodeHash = keccak256(minimalProxyCreationCode(_fxERC721Token));
    }

    

    /**
     * @notice Map a token to enable its movement via the PoS Portal, callable by anyone
     * @param rootToken address of token on root chain
     */
    

    function deposit(
        address rootToken,
        address user,
        uint256 tokenId,
        bytes memory data
    ) public {
    }

    // exit processor
    function _processMessageFromChild(bytes memory data) internal override {
        (address rootToken, address childToken, address to, uint256 tokenId, bytes memory syncData) = abi.decode(
            data,
            (address, address, address, uint256, bytes)
        );
        // validate mapping for root to child

        // transfer from tokens to
        EthNft(rootToken).safeTransferFrom(address(this), to, tokenId, syncData);
        emit FxWithdrawERC721(rootToken, childToken, to, tokenId);
    }
}