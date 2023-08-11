// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


contract DecentraWebTokenLocker is Initializable, ContextUpgradeable, OwnableUpgradeable {
    using SafeMathUpgradeable for uint;
    using AddressUpgradeable for address;

    struct LockInfo {
        uint128 amount;
        uint128 claimedAmount;
        uint64 lockTimestamp; 
        uint64 lastUpdated;
        uint32 lockHours;
    }

    address public token;
    address public admin;
    mapping (address => LockInfo) public lockData;

    modifier onlyContract(address account)
    {
        require(account.isContract(), "[Validation] The address does not contain a contract");
        _;
    }

    modifier onlyAdmin(address account)
    {
        require(account == admin, "[Validation] not called by admin");
        _;
    }

    function initialize(address _admin, address _token) external initializer onlyContract(_token)
    {
        __DecentraWebTokenLocker_init(_admin, _token);
    }
function __DecentraWebTokenLocker_init(address _admin, address _token) internal initializer
    {
        __Context_init_unchained();
        __Ownable_init_unchained();

        token = _token;
        admin = _admin;
    }

    function getToken() external view returns(address) {
        return token;
    }

    function setAdminAccount(address _admin) external onlyOwner() {
        admin = _admin;
    }

    function emergencyWithdraw() external onlyOwner() {
        IERC20Upgradeable(token).transfer(_msgSender(), IERC20Upgradeable(token).balanceOf(address(this)));
    }

    function emergencyPartialWithdraw(uint256 _amount) external onlyOwner() {
        IERC20Upgradeable(token).transfer(_msgSender(), _amount);
    }

    function getLockData(address _user) external view returns(uint128, uint128, uint64, uint64, uint32) {
        require(_user != address(0), "User address is invalid");
        LockInfo storage _lockInfo = lockData[_user];
        return (
            _lockInfo.amount, 
            _lockInfo.claimedAmount, 
            _lockInfo.lockTimestamp, 
            _lockInfo.lastUpdated, 
            _lockInfo.lockHours);
    }

    function sendLockTokenMany(
        address[] calldata _users, 
        uint128[] calldata _amounts, 
        uint32[] calldata _lockHours,
        uint256 _sendAmount
    ) external onlyAdmin(_msgSender()) {
        require(_users.length == _amounts.length, "array length not eq");
        require(_users.length == _lockHours.length, "array length not eq");
        require(_sendAmount > 0 , "Amount is invalid");
        IERC20Upgradeable(token).transferFrom(_msgSender(), address(this), _sendAmount);
        for (uint256 j = 0; j < _users.length; j++) {
            sendLockToken(_users[j], _amounts[j], uint64(block.timestamp), _lockHours[j]);
        }
    }

    function sendLockToken(
        address _user, 
        uint128 _amount, 
        uint64 _lockTimestamp, 
        uint32 _lockHours
    ) internal {
        require(_amount > 0, "amount can not zero");
        require(_lockHours > 0, "lock hours need more than zero");
        require(_lockTimestamp > 0, "lock timestamp need more than zero");
        require(lockData[_user].amount == 0, "this address has already locked");
        LockInfo memory lockinfo = LockInfo({
            amount: _amount,
            lockTimestamp: _lockTimestamp,
            lockHours: _lockHours,
            lastUpdated: uint64(block.timestamp),
            claimedAmount: 0
        });
        lockData[_user] = lockinfo;
    }

    function removeLock(address _user) external onlyAdmin(_msgSender()) {
        require(_user != address(0), "User address is invalid");
        delete lockData[_user];
    }
function claimToken(uint128 _amount) external returns (uint256) {
        require(_amount > 0, "Invalid parameter amount");
        address _user = _msgSender();
        LockInfo storage _lockInfo = lockData[_user];
        require(_lockInfo.lockTimestamp <= block.timestamp, "Vesting time is not started");
        require(_lockInfo.amount > 0, "No lock token to claim");
        uint256 passhours = block.timestamp.sub(_lockInfo.lockTimestamp).div(1 hours);
        require(passhours > 0, "need wait for one hour at least");
        require((block.timestamp - _lockInfo.lastUpdated) > 1 hours, "You have to wait at least an hour to claim");
        uint256 available = 0;
        if (passhours >= _lockInfo.lockHours) {
            available = _lockInfo.amount;
        } else {
            available = uint256(_lockInfo.amount).div(_lockInfo.lockHours).mul(passhours);
        }
        available = available.sub(_lockInfo.claimedAmount);
        require(available > 0, "not available claim");
        uint256 claim = _amount;
        if (_amount > available) { // claim as much as possible
            claim = available;
        }
        _lockInfo.claimedAmount = uint128(uint256(_lockInfo.claimedAmount).add(claim));
        IERC20Upgradeable(token).transfer(_user, claim);
        _lockInfo.lastUpdated = uint64(block.timestamp);
        return claim;
    }
    function abc() public pure returns (uint  a){
        a=5;
    }
}
