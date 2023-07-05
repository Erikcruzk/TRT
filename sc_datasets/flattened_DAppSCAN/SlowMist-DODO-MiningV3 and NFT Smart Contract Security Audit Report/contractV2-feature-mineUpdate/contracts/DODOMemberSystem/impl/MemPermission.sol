// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/Ownable.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract Ownable {
    address public _OWNER_;
    address public _NEW_OWNER_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    constructor() internal {
        _OWNER_ = msg.sender;
        emit OwnershipTransferred(address(0), _OWNER_);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() external {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/InitializableOwnable.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @author DODO Breeder
 *
 * @notice Ownership related functions
 */
contract InitializableOwnable {
    address public _OWNER_;
    address public _NEW_OWNER_;
    bool internal _INITIALIZED_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier notInitialized() {
        require(!_INITIALIZED_, "DODO_INITIALIZED");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    function initOwner(address newOwner) public notInitialized {
        _INITIALIZED_ = true;
        _OWNER_ = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() public {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/PermissionManager.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface IPermissionManager {
    function initOwner(address) external;

    function isAllowed(address) external view returns (bool);
}

contract PermissionManager is InitializableOwnable {
    bool public _WHITELIST_MODE_ON_;

    mapping(address => bool) internal _whitelist_;
    mapping(address => bool) internal _blacklist_;

    function isAllowed(address account) external view returns (bool) {
        if (_WHITELIST_MODE_ON_) {
            return _whitelist_[account];
        } else {
            return !_blacklist_[account];
        }
    }

    function openBlacklistMode() external onlyOwner {
        _WHITELIST_MODE_ON_ = false;
    }

    function openWhitelistMode() external onlyOwner {
        _WHITELIST_MODE_ON_ = true;
    }

    function addToWhitelist(address account) external onlyOwner {
        _whitelist_[account] = true;
    }

    function removeFromWhitelist(address account) external onlyOwner {
        _whitelist_[account] = false;
    }

    function addToBlacklist(address account) external onlyOwner {
        _blacklist_[account] = true;
    }

    function removeFromBlacklist(address account) external onlyOwner {
        _blacklist_[account] = false;
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/SafeMath.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


/**
 * @title SafeMath
 * @author DODO Breeder
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = x / 2 + 1;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/DecimalMath.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title DecimalMath
 * @author DODO Breeder
 *
 * @notice Functions for fixed point number with 18 decimals
 */
library DecimalMath {
    using SafeMath for uint256;

    uint256 internal constant ONE = 10**18;
    uint256 internal constant ONE2 = 10**36;

    function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
        return target.mul(d) / (10**18);
    }

    function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
        return target.mul(d).divCeil(10**18);
    }

    function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
        return target.mul(10**18).div(d);
    }

    function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
        return target.mul(10**18).divCeil(d);
    }

    function reciprocalFloor(uint256 target) internal pure returns (uint256) {
        return uint256(10**36).div(target);
    }

    function reciprocalCeil(uint256 target) internal pure returns (uint256) {
        return uint256(10**36).divCeil(target);
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/DODOMemberSystem/impl/MemAggregator.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;



interface IMemSource {
    function getMemLevel(address user) external returns (uint256);
}

contract MemRegistry is Ownable {
    using SafeMath for uint256;

    address[] internal _VALID_MEM_SOURCE_LIST_;
    mapping(address => bool) internal _VALID_MEM_SOURCE_;
    mapping(address => uint256) internal _MEM_SOURCE_WEIGHT_;

    function getMemLevel(address user) public returns (uint256 memLevel) {
        for (uint8 i = 0; i < _VALID_MEM_SOURCE_LIST_.length; i++) {
            address _source = _VALID_MEM_SOURCE_LIST_[i];
            memLevel = memLevel.add(
                IMemSource(_source).getMemLevel(user).mul(_MEM_SOURCE_WEIGHT_[_source])
            );
        }
    }

    function setMemSourceWeight(address source, uint256 weight) external onlyOwner {
        _MEM_SOURCE_WEIGHT_[source] = weight;
    }

    function addMemSource(address source) external onlyOwner {
        require(!_VALID_MEM_SOURCE_[source], "SOURCE_ALREADY_EXIST");
        _VALID_MEM_SOURCE_LIST_.push(source);
        _VALID_MEM_SOURCE_[source] = true;
    }

    function removeMemSource(address source) external onlyOwner {
        require(_VALID_MEM_SOURCE_[source], "SOURCE_NOT_EXIST");
        for (uint8 i = 0; i <= _VALID_MEM_SOURCE_LIST_.length - 1; i++) {
            if (_VALID_MEM_SOURCE_LIST_[i] == source) {
                _VALID_MEM_SOURCE_LIST_[i] = _VALID_MEM_SOURCE_LIST_[_VALID_MEM_SOURCE_LIST_
                    .length - 1];
                _VALID_MEM_SOURCE_LIST_.pop();
                break;
            }
        }
        _VALID_MEM_SOURCE_[source] = false;
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/intf/IERC20.sol

// This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
// SPDX-License-Identifier: MIT

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/SafeERC20.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0
    This is a simplified version of OpenZepplin's SafeERC20 library

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/DODOMemberSystem/impl/MemSourceStake.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;






contract MemSourceStake is Ownable, IMemSource {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public _DODO_TOKEN_;
    uint256 public _DODO_RESERVE_;
    uint256 public _COLD_DOWN_DURATION_;

    mapping(address => uint256) internal _STAKED_DODO_;
    mapping(address => uint256) internal _PENDING_DODO_;
    mapping(address => uint256) internal _EXECUTE_TIME_;

    constructor(address dodoToken) public {
        _DODO_TOKEN_ = dodoToken;
    }

    // ============ Owner Function ============

    function setColdDownDuration(uint256 coldDownDuration) external onlyOwner {
        _COLD_DOWN_DURATION_ = coldDownDuration;
    }

    // ============ DODO Function ============

    function admitStakedDODO(address to) external {
        uint256 dodoInput = IERC20(_DODO_TOKEN_).balanceOf(address(this)).sub(_DODO_RESERVE_);
        _STAKED_DODO_[to] = _STAKED_DODO_[to].add(dodoInput);
        _sync();
    }

    function stakeDODO(uint256 amount) external {
        _transferDODOIn(msg.sender, amount);
        _STAKED_DODO_[msg.sender] = _STAKED_DODO_[msg.sender].add(amount);
        _sync();
    }

    function requestDODOWithdraw(uint256 amount) external {
        _STAKED_DODO_[msg.sender] = _STAKED_DODO_[msg.sender].sub(amount);
        _PENDING_DODO_[msg.sender] = _PENDING_DODO_[msg.sender].add(amount);
        _EXECUTE_TIME_[msg.sender] = block.timestamp.add(_COLD_DOWN_DURATION_);
    }

    function withdrawDODO() external {
        require(_EXECUTE_TIME_[msg.sender] <= block.timestamp, "WITHDRAW_COLD_DOWN");
        _transferDODOOut(msg.sender, _PENDING_DODO_[msg.sender]);
        _PENDING_DODO_[msg.sender] = 0;
    }

    // ============ Balance Function ============

    function _transferDODOIn(address from, uint256 amount) internal {
        IERC20(_DODO_TOKEN_).transferFrom(from, address(this), amount);
    }

    function _transferDODOOut(address to, uint256 amount) internal {
        IERC20(_DODO_TOKEN_).transfer(to, amount);
    }

    function _sync() internal {
        _DODO_RESERVE_ = IERC20(_DODO_TOKEN_).balanceOf(address(this));
    }

    // ============ View Function ============

    function getMemLevel(address user) external override returns (uint256) {
        return _STAKED_DODO_[user];
    }
}

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/DODOMemberSystem/impl/MemPermission.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;



contract MemPermission is Ownable {
    uint256 public _MEM_LEVEL_THRESHOLD_;
    address public _MEM_LEVEL_SOURCE_;

    constructor(address memLevelSource, uint256 memLevelThreshold) public {
        _MEM_LEVEL_THRESHOLD_ = memLevelThreshold;
        _MEM_LEVEL_SOURCE_ = memLevelSource;
    }

    function isAllowed(address account) external returns (bool) {
        return IMemSource(_MEM_LEVEL_SOURCE_).getMemLevel(account) >= _MEM_LEVEL_THRESHOLD_;
    }
}
