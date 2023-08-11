// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {PolyNft} from "./PolyNft.sol";
import {FxBaseChildTunnel} from "./FxBaseChildTunnel.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Create2} from "lib/Create2.sol";
import {IFxERC721} from "./IFxERC721.sol";
import {IERC721Receiver} from "lib/IERC721Receiver.sol";

contract FxERC721ChildTunnel is OwnableUpgradeable,FxBaseChildTunnel, Create2, IERC721Receiver {
    address public childToken;
    address public rootToken;

    address public custodyContract;
    // bool 
    bool public bridgeState;

    // root to child token
    mapping(address => address) public rootToChildToken;

    bytes32 public constant MAP_TOKEN = keccak256("MAP_TOKEN");
    bytes32 public constant DEPOSIT = keccak256("DEPOSIT");
    string public constant SUFFIX_NAME = " (FXERC721)";
    string public constant PREFIX_SYMBOL = "fx";
    
    // token template
    address public tokenTemplate;

    //events
    event SetChildToken(address childToken);
    event SetRootToken(address rootToken);
    event SetCustodyContract(address custodyContract);
    event Withdraw(address rootToken, address childToken, address receiver,uint256[] tokenId, uint256[] expiry);
    event TokenMapped(address indexed rootToken, address indexed childToken);

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
        address _fxChild,
        address _tokenTemplate) 
        external initializer {
            __FxERC721ChildTunnel_init(_childToken, _rootToken, _fxChild, _tokenTemplate);
    } 

    function __FxERC721ChildTunnel_init(address _childToken, address _rootToken, address _fxChild, address _tokenTemplate) internal initializer {
        __Ownable_init_unchained();
        __FxBaseChildTunnel_init(_fxChild);
        childToken = _childToken;
        rootToken = _rootToken;
        tokenTemplate = _tokenTemplate;
    }

    function onERC721Received(
        address /* operator */,
        address /* from */,
        uint256 /* tokenId */,
        bytes calldata /* data */
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
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

    function setCustodyContractAddress(address _custodyContract) external onlyOwner { 
        require(_custodyContract != address(0),"Should be not zero");
        custodyContract = _custodyContract;
        emit SetCustodyContract(custodyContract);
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
        (bytes32 syncType, bytes memory syncData) = abi.decode(data, (bytes32, bytes));

        if (syncType == DEPOSIT) {
            _syncDeposit(syncData);
        } else if (syncType == MAP_TOKEN) {
            _mapToken(syncData);
        } else {
            revert("FxERC721ChildTunnel: INVALID_SYNC_TYPE");
        }
    }

    function _mapToken(bytes memory syncData) internal returns (address) {
        (address rootToken, string memory name, string memory symbol) = abi.decode(syncData, (address, string, string));

        // get root to child token
        address childToken = rootToChildToken[rootToken];

        // check if it's already mapped
        require(childToken == address(0x0), "FxERC721ChildTunnel: ALREADY_MAPPED");

        // deploy new child token
        bytes32 salt = keccak256(abi.encodePacked(rootToken));
        childToken = createClone(salt, tokenTemplate);
        // slither-disable-next-line reentrancy-no-eth
        IFxERC721(childToken).initialize(
            address(this),
            rootToken,
            string(abi.encodePacked(name, SUFFIX_NAME)),
            string(abi.encodePacked(PREFIX_SYMBOL, symbol))
        );

        // map the token
        rootToChildToken[rootToken] = childToken;
        emit TokenMapped(rootToken, childToken);

        // return new child token
        return childToken;
    }
    
    function _syncDeposit(bytes memory syncData) internal {
        (address rootToken, address depositor, address to, uint256 tokenId, uint256 expiry, bytes memory depositData) = abi.decode(
            syncData,
            (address, address, address, uint256, uint256, bytes)
        );
        address childToken = rootToChildToken[rootToken];

        // deposit tokens
        PolyNft childTokenContract = PolyNft(childToken);
        childTokenContract.mintForBridge(to, tokenId, expiry);
    }

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

