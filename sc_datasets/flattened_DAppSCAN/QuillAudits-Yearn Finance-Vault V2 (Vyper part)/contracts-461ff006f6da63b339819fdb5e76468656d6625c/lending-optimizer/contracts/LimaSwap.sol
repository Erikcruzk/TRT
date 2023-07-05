// File: @openzeppelin/contracts-ethereum-package/contracts/Initializable.sol

pragma solidity >=0.4.24 <0.7.0;


/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract ContextUpgradeSafe is Initializable {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.

    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {


    }


    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol

pragma solidity ^0.6.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract OwnableUpgradeSafe is Initializable, ContextUpgradeSafe {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */

    function __Ownable_init() internal initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {


        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);

    }


    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    uint256[49] private __gap;
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

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
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
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
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/Address.sol

pragma solidity ^0.6.2;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

// File: @openzeppelin/contracts-ethereum-package/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.6.0;



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
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
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
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: @openzeppelin/contracts-ethereum-package/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.6.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuardUpgradeSafe is Initializable {
    bool private _notEntered;


    function __ReentrancyGuard_init() internal initializer {
        __ReentrancyGuard_init_unchained();
    }

    function __ReentrancyGuard_init_unchained() internal initializer {


        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;

    }


    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }

    uint256[49] private __gap;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/Compound.sol

pragma solidity ^0.6.6;

interface Compound {
    function mint(uint256 mintAmount) external returns (uint256);

    function redeem(uint256 redeemTokens) external returns (uint256);

    function exchangeRateStored() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/Aave.sol

pragma solidity ^0.6.6;

interface Aave {
    function deposit(
        address _reserve,
        uint256 _amount,
        uint16 _code
    ) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/AToken.sol

pragma solidity ^0.6.6;

interface AToken {
    function redeem(uint256 amount) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/ICurve.sol

pragma solidity ^0.6.6;

interface ICurve {
    // solium-disable-next-line mixedcase
    function get_dy_underlying(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    // solium-disable-next-line mixedcase
    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256 dy);

    // solium-disable-next-line mixedcase
    function exchange_underlying(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;

    // solium-disable-next-line mixedcase
    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 minDy
    ) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/interfaces/IOneSplit.sol

pragma solidity ^0.6.2;

interface IOneSplit {
    function getExpectedReturn(
        IERC20 fromToken,
        IERC20 destToken,
        uint256 amount,
        uint256 parts,
        uint256 flags // See constants in IOneSplit.sol
    )
        external
        view
        returns (uint256 returnAmount, uint256[] memory distribution);

    function swap(
        IERC20 fromToken,
        IERC20 destToken,
        uint256 amount,
        uint256 minReturn,
        uint256[] calldata distribution,
        uint256 flags
    ) external payable returns (uint256 returnAmount);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Yearn Finance-Vault V2 (Vyper part)/contracts-461ff006f6da63b339819fdb5e76468656d6625c/lending-optimizer/contracts/LimaSwap.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;







contract AddressStorage is OwnableUpgradeSafe {
    enum Lender {NOT_FOUND, COMPOUND, AAVE}
    enum TokenType {NOT_FOUND, STABLE_COIN, INTEREST_TOKEN}

    address internal constant dai = address(
        0x6B175474E89094C44Da98b954EedeAC495271d0F
    );
    address internal constant usdc = address(
        0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
    );
    address internal constant usdt = address(
        0xdAC17F958D2ee523a2206206994597C13D831ec7
    );

    //governance token
    address internal constant AAVE = address(
        0x7Fc66500c84A76Ad7e9c93437bFc5Ac33E2DDaE9
    );
    address internal constant COMP = address(
        0xc00e94Cb662C3520282E6f5717214004A7f26888
    );

    address public aaveLendingPool;
    address public aaveCore;
    address public curve;
    address public oneInchPortal;

    mapping(address => Lender) public lenders;
    mapping(address => TokenType) public tokenTypes;
    mapping(address => address) public interestTokenToUnderlyingStablecoin;

    // @dev get ERC20 address for governance token from Compound or AAVE
    // @param _token ERC20 address
    function getGovernanceToken(address token) public view returns (address) {
        if (lenders[token] == Lender.COMPOUND) {
            return COMP;
        } else if (lenders[token] == Lender.AAVE) {
            return AAVE;
        } else {
            return address(0);
        }
    }

    // @dev get interest bearing token information
    // @param _token ERC20 address
    // @return lender protocol (Lender) and TokenTypes enums
    function getTokenInfo(address interestBearingToken)
        public
        view
        returns (Lender, TokenType)
    {
        return (
            lenders[interestBearingToken],
            tokenTypes[interestBearingToken]
        );
    }

    // @dev set new Aave lending pool address
    // @param _newAaveLendingPool Aave lending pool address
    function setNewAaveLendingPool(address _newAaveLendingPool)
        public
        onlyOwner
    {
        require(
            _newAaveLendingPool != address(0),
            "new _newAaveLendingPool is empty"
        );
        aaveLendingPool = _newAaveLendingPool;
    }

    // @dev set new Aave core address
    // @param _newAaveCore Aave core address
    function setNewAaveCore(address _newAaveCore) public onlyOwner {
        require(_newAaveCore != address(0), "new _newAaveCore is empty");
        aaveCore = _newAaveCore;
    }

    // @dev set new curve pool
    // @param _newCurvePool Curve pool address
    function setNewCurvePool(address _newCurvePool) public onlyOwner {
        require(_newCurvePool != address(0), "new _newCurvePool is empty");
        curve = _newCurvePool;
    }

    // @dev set new 1Inch portal
    // @param _newOneInch Curve pool address
    function setNewOneInch(address _newOneInch) public onlyOwner {
        require(_newOneInch != address(0), "new _newOneInch is empty");
        oneInchPortal = _newOneInch;
    }

    // @dev set interest bearing token to its stable coin underlying
    // @param interestToken ERC20 address
    // @param underlyingToken stable coin ERC20 address
    function setInterestTokenToUnderlyingStablecoin(
        address interestToken,
        address underlyingToken
    ) public onlyOwner {
        require(
            interestToken != address(0) && underlyingToken != address(0),
            "token addresses must be entered"
        );

        interestTokenToUnderlyingStablecoin[interestToken] = underlyingToken;
    }

    // @dev set interest bearing token to a lender protocol
    // @param _token ERC20 address
    // @param _lender Integer which represents LENDER enum
    function setAddressToLender(address _token, Lender _lender)
        public
        onlyOwner
    {
        require(_token != address(0), "!_token");

        lenders[_token] = _lender;
    }

    // @dev set token to its type
    // @param _token ERC20 address
    // @param _tokenType Integer which represents TokenType enum
    function setAddressTokenType(address _token, TokenType _tokenType)
        public
        onlyOwner
    {
        require(_token != address(0), "!_token");

        tokenTypes[_token] = _tokenType;
    }
}

contract LimaSwap is AddressStorage, ReentrancyGuardUpgradeSafe {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    uint256 public constant MAX_UINT256 = 2**256 - 1;
    uint16 public constant aaveCode = 94;

    event Swapped(address from, address to, uint256 amount, uint256 result);

    function initialize() public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
        aaveLendingPool = address(0x398eC7346DcD622eDc5ae82352F02bE94C62d119);
        aaveCore = address(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);
        curve = address(0x45F783CCE6B7FF23B2ab2D70e416cdb7D6055f51); // yPool
        oneInchPortal = address(0x11111254369792b2Ca5d084aB5eEA397cA8fa48B); // 1Inch

        address cDai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
        address cUsdc = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;
        address cUsdt = 0xf650C3d88D12dB855b8bf7D11Be6C55A4e07dCC9;
        address aDai = 0xfC1E690f61EFd961294b3e1Ce3313fBD8aa4f85d;
        address aUsdc = 0x9bA00D6856a4eDF4665BcA2C2309936572473B7E;
        address aUsdt = 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8;

        // set token types
        setAddressTokenType(dai, TokenType.STABLE_COIN);
        setAddressTokenType(usdc, TokenType.STABLE_COIN);
        setAddressTokenType(usdt, TokenType.STABLE_COIN);

        setAddressTokenType(cDai, TokenType.INTEREST_TOKEN);
        setAddressTokenType(cUsdc, TokenType.INTEREST_TOKEN);
        setAddressTokenType(cUsdt, TokenType.INTEREST_TOKEN);

        setAddressTokenType(aDai, TokenType.INTEREST_TOKEN);
        setAddressTokenType(aUsdc, TokenType.INTEREST_TOKEN);
        setAddressTokenType(aUsdt, TokenType.INTEREST_TOKEN);

        // set interest bearing tokens to lenders
        setAddressToLender(cDai, Lender.COMPOUND); // compoundDai
        setAddressToLender(cUsdc, Lender.COMPOUND); // compoundUSDC
        setAddressToLender(cUsdt, Lender.COMPOUND); // compoundUSDT

        setAddressToLender(aDai, Lender.AAVE); // aaveDai
        setAddressToLender(aUsdc, Lender.AAVE); // aaveUSDC
        setAddressToLender(aUsdt, Lender.AAVE); // aaveUSDT

        // set interest tokens to their underlying stable coins
        setInterestTokenToUnderlyingStablecoin(cDai, dai); //compoundDai
        setInterestTokenToUnderlyingStablecoin(aDai, dai); // aaveDai
        setInterestTokenToUnderlyingStablecoin(cUsdc, usdc); //compoundUsdc
        setInterestTokenToUnderlyingStablecoin(aUsdc, usdc); //aaveUsdc
        setInterestTokenToUnderlyingStablecoin(cUsdt, usdt); // compoundUsdt
        setInterestTokenToUnderlyingStablecoin(aUsdt, usdt); // aaveUsdt

        // infinitely approve tokens
        IERC20(dai).safeApprove(aaveCore, MAX_UINT256);
        IERC20(dai).safeApprove(cDai, MAX_UINT256); // compoundDai
        IERC20(dai).safeApprove(curve, MAX_UINT256); // curve

        IERC20(usdc).safeApprove(aaveCore, MAX_UINT256);
        IERC20(usdc).safeApprove(cUsdc, MAX_UINT256); // compoundUSDC
        IERC20(usdc).safeApprove(curve, MAX_UINT256); // curve

        IERC20(usdt).safeApprove(aaveCore, MAX_UINT256);
        IERC20(usdt).safeApprove(cUsdt, MAX_UINT256); // compoundUSDT
        IERC20(usdt).safeApprove(curve, MAX_UINT256); // curve
    }

    /* ============ Public ============ */

    // @dev only used for stable coins usdt usdc and dai
    // @param fromToken from ERC20 address
    // @param toToken destination ERC20 address
    // @param amount Number in fromToken
    function getExpectedReturn(
        address fromToken,
        address toToken,
        uint256 amount
    ) public view returns (uint256 returnAmount) {
        (int128 i, int128 j) = _calculateCurveSelector(
            IERC20(fromToken),
            IERC20(toToken)
        );

        returnAmount = ICurve(curve).get_dy_underlying(i, j, amount);
    }

    // @dev Add function to remove locked tokens that may be sent by users accidently to the contract
    // @param token ERC20 address of token
    // @param recipient Beneficiary of the token transfer
    // @param amount Number to tranfer
    function removeLockedErc20(
        address token,
        address recipient,
        uint256 amount
    ) external onlyOwner {
        IERC20(token).safeTransfer(recipient, amount);
    }

    // @dev balance of an ERC20 token within swap contract
    // @param token ERC20 token address
    function balanceOfToken(address token) public view returns (uint256) {
        return IERC20(token).balanceOf(address(this));
    }

    // @dev swap from token A to token B for sender. Receiver of funds needs to be passed. Sender needs to approve LimaSwap to use her tokens
    // @param recipient Beneficiary of the swap tx
    // @param from ERC20 address of token to swap from
    // @param to ERC20 address to swap to
    // @param amount from Token value to swap
    // @param minReturnAmount Minimum amount that needs to be returned. Used to prevent frontrunning
    function swap(
        address recipient,
        address from,
        address to,
        uint256 amount,
        uint256 minReturnAmount
    ) public nonReentrant returns (uint256) {
        uint256 balanceofSwappedtoken;

        // non core swaps
        if (
            tokenTypes[from] == TokenType.NOT_FOUND ||
            tokenTypes[to] == TokenType.NOT_FOUND
        ) {
            (uint256 retAmount, uint256[] memory distribution) = IOneSplit(
                oneInchPortal
            )
                .getExpectedReturn(IERC20(from), IERC20(to), amount, 1, 0);

            balanceofSwappedtoken = IOneSplit(oneInchPortal).swap(
                IERC20(from),
                IERC20(to),
                amount,
                retAmount,
                distribution,
                0 // flags
            );
        } else {
            // core swaps
            uint256 returnedAmount = _swapCoreTokens(
                from,
                to,
                amount,
                minReturnAmount
            );
            balanceofSwappedtoken = returnedAmount;
        }

        IERC20(to).safeTransfer(recipient, balanceofSwappedtoken);

        emit Swapped(from, to, amount, balanceofSwappedtoken);

        return balanceofSwappedtoken;
    }

    // @dev swap interesting bearing token to its underlying from either AAve or Compound
    // @param interestBearingToken ERC20 address of interest bearing token
    // @param amount Interest bearing token value
    // @param recipient Beneficiary of the tx
    function unwrap(
        address interestBearingToken,
        uint256 amount,
        address recipient
    ) public nonReentrant {
        (Lender l, TokenType t) = getTokenInfo(interestBearingToken);
        require(t == TokenType.INTEREST_TOKEN, "not an interest bearing token");

        _transferAmountToSwap(interestBearingToken, amount);
        if (l == Lender.COMPOUND) {
            _withdrawCompound(interestBearingToken);
        } else if (l == Lender.AAVE) {
            _withdrawAave(interestBearingToken);
        }

        address u = interestTokenToUnderlyingStablecoin[interestBearingToken];

        uint256 balanceofSwappedtoken = balanceOfToken(u);
        IERC20(u).safeTransfer(recipient, balanceofSwappedtoken);
    }

    /* ============ Internal ============ */
    function _swapCoreTokens(
        address from,
        address to,
        uint256 amount,
        uint256 minReturnAmount
    ) internal returns (uint256 balanceofSwappedtoken) {
        address fromTokencalculatedUnderlyingStablecoin;

        // from token calculations
        if (tokenTypes[from] == TokenType.INTEREST_TOKEN) {
            _transferAmountToSwap(from, amount);
            if (lenders[from] == Lender.COMPOUND) {
                _withdrawCompound(from);
            } else if (lenders[from] == Lender.AAVE) {
                _withdrawAave(from);
            }

            fromTokencalculatedUnderlyingStablecoin = interestTokenToUnderlyingStablecoin[from];
        } else {
            _transferAmountToSwap(from, amount);
            fromTokencalculatedUnderlyingStablecoin = from;
        }

        // to token calculations
        if (tokenTypes[to] == TokenType.STABLE_COIN) {
            if (fromTokencalculatedUnderlyingStablecoin == to) {
                balanceofSwappedtoken = balanceOfToken(
                    fromTokencalculatedUnderlyingStablecoin
                );
            } else {
                _swapViaCurve(
                    fromTokencalculatedUnderlyingStablecoin,
                    to,
                    minReturnAmount
                );
                balanceofSwappedtoken = balanceOfToken(to);
            }
        } else {
            address toTokenStablecoin = interestTokenToUnderlyingStablecoin[to];

            if (fromTokencalculatedUnderlyingStablecoin != toTokenStablecoin) {
                _swapViaCurve(
                    fromTokencalculatedUnderlyingStablecoin,
                    toTokenStablecoin,
                    minReturnAmount
                );
            }

            uint256 balanceToTokenStableCoin = balanceOfToken(
                toTokenStablecoin
            );

            if (balanceToTokenStableCoin > 0) {
                if (lenders[to] == Lender.COMPOUND) {
                    _supplyCompound(to, balanceToTokenStableCoin);
                } else if (lenders[to] == Lender.AAVE) {
                    _supplyAave(toTokenStablecoin, balanceToTokenStableCoin);
                }
            }

            balanceofSwappedtoken = balanceOfToken(to);
        }
    }

    function _transferAmountToSwap(address from, uint256 amount) internal {
        IERC20(from).safeTransferFrom(msg.sender, address(this), amount);
    }

    // curve interface functions
    function _calculateCurveSelector(IERC20 fromToken, IERC20 toToken)
        internal
        pure
        returns (int128, int128)
    {
        IERC20[] memory tokens = new IERC20[](3);
        tokens[0] = IERC20(dai);
        tokens[1] = IERC20(usdc);
        tokens[2] = IERC20(usdt);

        int128 i = 0;
        int128 j = 0;
        for (uint256 t = 0; t < tokens.length; t++) {
            if (fromToken == tokens[t]) {
                i = int128(t + 1);
            }
            if (toToken == tokens[t]) {
                j = int128(t + 1);
            }
        }

        return (i - 1, j - 1);
    }

    function _swapViaCurve(
        address from,
        address to,
        uint256 minAmountToPreventFrontrunning
    ) internal {
        (int128 i, int128 j) = _calculateCurveSelector(
            IERC20(from),
            IERC20(to)
        );
        uint256 balanceStabletoken = balanceOfToken(from);

        ICurve(curve).exchange_underlying(
            i,
            j,
            balanceStabletoken,
            minAmountToPreventFrontrunning
        );
    }

    // compound interface functions
    function _supplyCompound(address interestToken, uint256 amount) internal {
        require(
            Compound(interestToken).mint(amount) == 0,
            "COMPOUND: supply failed"
        );
    }

    function _withdrawCompound(address cToken) internal {
        uint256 balanceInCToken = IERC20(cToken).balanceOf(address(this));
        if (balanceInCToken > 0) {
            require(
                Compound(cToken).redeem(balanceInCToken) == 0,
                "COMPOUND: withdraw failed"
            );
        }
    }

    // aave interface functions
    function _supplyAave(address _underlyingToken, uint256 amount) internal {
        Aave(aaveLendingPool).deposit(_underlyingToken, amount, aaveCode);
    }

    function _withdrawAave(address aToken) internal {
        uint256 amount = IERC20(aToken).balanceOf(address(this));

        if (amount > 0) {
            AToken(aToken).redeem(amount);
        }
    }
}
