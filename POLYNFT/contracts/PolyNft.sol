// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract PolyNft is OwnableUpgradeable, ERC721Upgradeable{
    uint256 public count;
    // // Mapping from token ID to approved address
    // mapping(uint256 => address) private _tokenApprovals;
    mapping(address => bool) public controllers;
    mapping(uint256=>uint256) private expiries;

    function initialize() external initializer {
        __ERC721_init("POLYNFT","PFT");
        __Ownable_init();
        count=1000;
    }

    function mintToken(address to, uint expiry) external {
        uint256 tokenId = count;
        require(expiry>=1 && expiry<=5,"Expiry years not within the range");
        expiry = block.timestamp + (expiry * 356 days);
        setExpiry(tokenId, expiry);
        _safeMint(to, tokenId);
        count++;
    }

    function mintForBridge(address to, uint256 tokenId, uint256 timestamp ) external {
        setExpiry(tokenId, timestamp);
        _safeMint(to, tokenId);
    }

    function burnToken(uint256 tokenId) external onlyController{
        _burn(tokenId);
        // _transfer(_from, _to, tokenId);
    }

    // function burnFromCustody(uint256[] memory tokenId) external {
    //     for(uint256 i = 0; i < tokenId.length; i++) {
    //         _burn(tokenId[i]);
    //     }
    // }

    function setExpiry(uint256 id, uint expiry) virtual  internal{
        expiries[id] = expiry;
    }   

    function nameExpires(uint256 id) external virtual view returns(uint) {
        return expiries[id];
    }

    function ownerOf(uint256 tokenId) public view virtual override(ERC721Upgradeable) returns (address) {
        return super.ownerOf(tokenId);
    }

    function setController(address controller, bool enabled) external onlyOwner {
        controllers[controller] = enabled;
    }

    modifier onlyController {
        require(
            controllers[msg.sender],
            "Controllable: Caller is not a controller"
        );
        _;
    }

    
}
