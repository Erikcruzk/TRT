// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-dloop Art Registry Smart Contract/art-registry-2ccd432a6628aabf5934a24d165100e65b448e7f/src/DloopAdmin.sol

pragma solidity 0.5.17;

contract DloopAdmin {
    mapping(address => bool) private _adminMap;
    uint256 private _adminCount = 0;

    event AdminAdded(address indexed account);
    event AdminRenounced(address indexed account);

    constructor() public {
        _adminMap[msg.sender] = true;
        _adminCount = 1;
    }

    modifier onlyAdmin() {
        require(_adminMap[msg.sender], "caller does not have the admin role");
        _;
    }

    function numberOfAdmins() public view returns (uint256) {
        return _adminCount;
    }

    function isAdmin(address account) public view returns (bool) {
        return _adminMap[account];
    }

    function addAdmin(address account) public onlyAdmin {
        require(!_adminMap[account], "account already has admin role");
        require(account != address(0x0), "account must not be 0x0");
        _adminMap[account] = true;
        _adminCount = SafeMath.add(_adminCount, 1);
        emit AdminAdded(account);
    }

    function renounceAdmin() public onlyAdmin {
        _adminMap[msg.sender] = false;
        _adminCount = SafeMath.sub(_adminCount, 1);
        require(_adminCount > 0, "minimum one admin required");
        emit AdminRenounced(msg.sender);
    }
}

// File: ../sc_datasets/DAppSCAN/Quantstamp-dloop Art Registry Smart Contract/art-registry-2ccd432a6628aabf5934a24d165100e65b448e7f/src/DloopGovernance.sol

// SWC-Floating Pragma: L2
pragma solidity 0.5.17;


contract DloopGovernance is DloopAdmin {
    bool private _minterRoleEnabled = true;
    mapping(address => bool) private _minterMap;
    uint256 private _minterCount = 0;

    event AllMintersDisabled(address indexed sender);
    event AllMintersEnabled(address indexed sender);
    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    constructor() public {
        addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(_minterRoleEnabled, "all minters are disabled");
        require(isMinter(msg.sender), "caller does not have the minter role");
        _;
    }

    function disableAllMinters() public onlyMinter {
        _minterRoleEnabled = false;
        emit AllMintersDisabled(msg.sender);
    }

    function enableAllMinters() public onlyAdmin {
        require(!_minterRoleEnabled, "minters already enabled");
        _minterRoleEnabled = true;
        emit AllMintersEnabled(msg.sender);
    }

    function isMinter(address account) public view returns (bool) {
        require(_minterRoleEnabled, "all minters are disabled");
        return _minterMap[account];
    }

    function isMinterRoleActive() public view returns (bool) {
        return _minterRoleEnabled;
    }

    function addMinter(address account) public onlyAdmin {
        require(!_minterMap[account], "account already has minter role");
        _minterMap[account] = true;
        _minterCount = SafeMath.add(_minterCount, 1);
        emit MinterAdded(account);
    }

    function removeMinter(address account) public onlyAdmin {
        require(_minterMap[account], "account does not have minter role");
        _minterMap[account] = false;
        _minterCount = SafeMath.sub(_minterCount, 1);
        emit MinterRemoved(account);
    }

    function numberOfMinters() public view returns (uint256) {
        return _minterCount;
    }
}
