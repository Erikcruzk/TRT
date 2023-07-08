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

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/ReentrancyGuard.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

/**
 * @title ReentrancyGuard
 * @author DODO Breeder
 *
 * @notice Protect functions from Reentrancy Attack
 */
contract ReentrancyGuard {
    // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
    // zero-state of _ENTERED_ is false
    bool private _ENTERED_;

    modifier preventReentrant() {
        require(!_ENTERED_, "REENTRANT");
        _ENTERED_ = true;
        _;
        _ENTERED_ = false;
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

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/lib/FeeRateModel.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;

interface IFeeRateImpl {
    function getFeeRate(address pool, address trader) external view returns (uint256);
}

interface IFeeRateModel {
    function getFeeRate(address trader) external view returns (uint256);
}

contract FeeRateModel is InitializableOwnable {
    address public feeRateImpl;

    function setFeeProxy(address _feeRateImpl) public onlyOwner {
        feeRateImpl = _feeRateImpl;
    }
    
    function getFeeRate(address trader) external view returns (uint256) {
        if(feeRateImpl == address(0))
            return 0;
        return IFeeRateImpl(feeRateImpl).getFeeRate(msg.sender,trader);
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

// File: ../sc_datasets/DAppSCAN/SlowMist-DODO-MiningV3 and NFT Smart Contract Security Audit Report/contractV2-feature-mineUpdate/contracts/CrowdPooling/impl/CPStorage.sol

/*

    Copyright 2020 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;
pragma experimental ABIEncoderV2;






contract CPStorage is InitializableOwnable, ReentrancyGuard {
    using SafeMath for uint256;

    // ============ Constant ============
    
    uint256 internal constant _SETTLEMENT_EXPIRE_ = 86400 * 7;
    uint256 internal constant _SETTEL_FUND_ = 200 finney;
    bool public _IS_OPEN_TWAP_ = false;

    // ============ Timeline ============

    uint256 public _PHASE_BID_STARTTIME_;
    uint256 public _PHASE_BID_ENDTIME_;
    uint256 public _PHASE_CALM_ENDTIME_;
    uint256 public _SETTLED_TIME_;
    bool public _SETTLED_;

    // ============ Core Address ============

    IERC20 public _BASE_TOKEN_;
    IERC20 public _QUOTE_TOKEN_;

    // ============ Distribution Parameters ============

    uint256 public _TOTAL_BASE_;
    uint256 public _POOL_QUOTE_CAP_;

    // ============ Settlement ============

    uint256 public _QUOTE_RESERVE_;

    uint256 public _UNUSED_BASE_;
    uint256 public _UNUSED_QUOTE_;

    uint256 public _TOTAL_SHARES_;
    mapping(address => uint256) internal _SHARES_;
    mapping(address => bool) public _CLAIMED_;

    address public _POOL_FACTORY_;
    address public _POOL_;
    uint256 public _AVG_SETTLED_PRICE_;

    // ============ Advanced Control ============

    address public _MAINTAINER_;
    IFeeRateModel public _MT_FEE_RATE_MODEL_;
    IPermissionManager public _BIDDER_PERMISSION_;

    // ============ PMM Parameters ============

    uint256 public _K_;
    uint256 public _I_;

    // ============ LP Token Vesting ============

    uint256 public _TOTAL_LP_AMOUNT_;
    uint256 public _FREEZE_DURATION_;
    uint256 public _VESTING_DURATION_;
    uint256 public _CLIFF_RATE_;

    // ============ Modifiers ============

    modifier phaseBid() {
        require(
            block.timestamp >= _PHASE_BID_STARTTIME_ && block.timestamp < _PHASE_BID_ENDTIME_,
            "NOT_PHASE_BID"
        );
        _;
    }

    modifier phaseCalm() {
        require(
            block.timestamp >= _PHASE_BID_ENDTIME_ && block.timestamp < _PHASE_CALM_ENDTIME_,
            "NOT_PHASE_CALM"
        );
        _;
    }

    modifier phaseBidOrCalm() {
        require(
            block.timestamp >= _PHASE_BID_STARTTIME_ && block.timestamp < _PHASE_CALM_ENDTIME_,
            "NOT_PHASE_BID_OR_CALM"
        );
        _;
    }

    modifier phaseSettlement() {
        require(block.timestamp >= _PHASE_CALM_ENDTIME_, "NOT_PHASE_EXE");
        _;
    }

    modifier phaseVesting() {
        require(_SETTLED_, "NOT_VESTING");
        _;
    }
}
