// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract Test is OwnableUpgradeable {
    //address of child token contract
    address public decentraNamePolygon;

    event SetPolyDwebToken(address decentraNamePolygon);

    function initialize() 
        external initializer {
            __FxERC721ChildTunnel_init();
    } 

    function __FxERC721ChildTunnel_init() 
        internal 
        initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function setDecentraNamePolygonAddressState(address _decentraNamePolygon)
        external
        onlyOwner
    {
        require(_decentraNamePolygon != address(0), "Invalid addr");
        decentraNamePolygon = _decentraNamePolygon;

        emit SetPolyDwebToken(decentraNamePolygon);
    }

    function setDecentraNamePolygonAddresslocal(address _decentraNamePolygon)
        external
        onlyOwner
    {
        require(_decentraNamePolygon != address(0), "Invalid addr");
        decentraNamePolygon = _decentraNamePolygon;
        
        emit SetPolyDwebToken(_decentraNamePolygon);
    }

    function readLocal(address _decentraNamePolygon) external view onlyOwner returns (address) {
        return _decentraNamePolygon;
    }

    function readState() external view onlyOwner returns (address){
        return decentraNamePolygon;
    }
}
