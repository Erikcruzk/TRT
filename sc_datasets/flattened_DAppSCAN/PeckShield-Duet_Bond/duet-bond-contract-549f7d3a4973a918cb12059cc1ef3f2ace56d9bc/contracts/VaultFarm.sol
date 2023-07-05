// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/interfaces/IVaultFarm.sol

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IVaultFarm {
  function syncDeposit(address _user, uint256 _amount, address asset) external;
  function syncWithdraw(address _user, uint256 _amount, address asset) external;
  function syncLiquidate(address _user, address asset) external;

}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/interfaces/ISingleBond.sol

pragma solidity >=0.8.0;

interface ISingleBond {
  function getEpoches() external view returns(address[] memory);
  function getEpoch(uint256 id) external view returns(address);
  function redeem(address[] memory epochs, uint[] memory amounts, address to) external;
  function redeemOrTransfer(address[] memory epochs, uint[] memory amounts, address to) external;
  function multiTransfer(address[] memory epochs, uint[] memory amounts, address to) external;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/interfaces/IEpoch.sol

pragma solidity >=0.8.0;

interface IEpoch {
  function end() external view returns (uint256);
  function bond() external view returns (address);
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/interfaces/IVault.sol

pragma solidity >=0.8.0;

interface IVault {
  function underlying() external view  returns (address);
  function deposits(address user) external view returns (uint256);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
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
     *
     * Furthermore, `isContract` will also return true if the target contract within
     * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
     * which only has an effect at the end of a transaction.
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (proxy/utils/Initializable.sol)

pragma solidity ^0.8.2;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
 * case an upgrade adds a module that needs to be initialized.
 *
 * For example:
 *
 * [.hljs-theme-light.nopadding]
 * ```solidity
 * contract MyToken is ERC20Upgradeable {
 *     function initialize() initializer public {
 *         __ERC20_init("MyToken", "MTK");
 *     }
 * }
 *
 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
 *     function initializeV2() reinitializer(2) public {
 *         __ERC20Permit_init("MyToken");
 *     }
 * }
 * ```
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() {
 *     _disableInitializers();
 * }
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     * @custom:oz-retyped-from bool
     */
    uint8 private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Triggered when the contract has been initialized or reinitialized.
     */
    event Initialized(uint8 version);

    /**
     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
     * `onlyInitializing` functions can be used to initialize parent contracts.
     *
     * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
     * constructor.
     *
     * Emits an {Initialized} event.
     */
    modifier initializer() {
        bool isTopLevelCall = !_initializing;
        require(
            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
            "Initializable: contract is already initialized"
        );
        _initialized = 1;
        if (isTopLevelCall) {
            _initializing = true;
        }
        _;
        if (isTopLevelCall) {
            _initializing = false;
            emit Initialized(1);
        }
    }

    /**
     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
     * used to initialize parent contracts.
     *
     * A reinitializer may be used after the original initialization step. This is essential to configure modules that
     * are added through upgrades and that require initialization.
     *
     * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
     * cannot be nested. If one is invoked in the context of another, execution will revert.
     *
     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
     * a contract, executing them in the right order is up to the developer or operator.
     *
     * WARNING: setting the version to 255 will prevent any future reinitialization.
     *
     * Emits an {Initialized} event.
     */
    modifier reinitializer(uint8 version) {
        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
        _initialized = version;
        _initializing = true;
        _;
        _initializing = false;
        emit Initialized(version);
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} and {reinitializer} modifiers, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    /**
     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
     * through proxies.
     *
     * Emits an {Initialized} event the first time it is successfully executed.
     */
    function _disableInitializers() internal virtual {
        require(!_initializing, "Initializable: contract is initializing");
        if (_initialized != type(uint8).max) {
            _initialized = type(uint8).max;
            emit Initialized(type(uint8).max);
        }
    }

    /**
     * @dev Returns the highest version that has been initialized. See {reinitializer}.
     */
    function _getInitializedVersion() internal view returns (uint8) {
        return _initialized;
    }

    /**
     * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
     */
    function _isInitializing() internal view returns (bool) {
        return _initializing;
    }
}

// File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract ContextUpgradeable is Initializable {
    function __Context_init() internal onlyInitializing {
    }

    function __Context_init_unchained() internal onlyInitializing {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[50] private __gap;
}

// File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


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
abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal onlyInitializing {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal onlyInitializing {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[49] private __gap;
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/Pool.sol

pragma solidity 0.8.11;



contract Pool {
  uint256 public constant SCALE = 1e12;
  address public farming;

  address[] public epoches;
  mapping(address => bool) public validEpoches;

  mapping(address => uint) public deposits;
  // user => epoch => debt
  mapping(address => mapping(address => uint)) public rewardDebt;
  mapping(address => mapping(address => uint)) public rewardAvailable;

  struct EpochInfo {
    uint accPerShare;       //Accumulated rewards per share, times SCALE
    uint epochPerSecond;   // for total deposit 
  }


  mapping(address => EpochInfo) public epochInfos;

  uint256 public totalAmount;
  uint256 public lastRewardSecond;
  uint256 public periodEnd;

  event Deposit(address indexed user, uint256 amount);
  event Withdraw(address indexed user, uint256 amount);

  constructor() {
  }

  modifier onlyFarming() {
    require(farming == msg.sender, "must call from framing");
    _;
  }

  function getEpoches() external view returns(address[] memory){
    return epoches;
  }

  function addEpoch(address epoch) internal {
    if(!validEpoches[epoch]) {
      validEpoches[epoch] = true;
      epoches.push(epoch);
    }
  }

  // remove some item for saving gas (array issue).
  // should only used when no such epoch assets.
  function remove(address epoch) external onlyFarming {
      require(validEpoches[epoch], "Not a valid epoch");
      validEpoches[epoch] = false;

      uint len = epoches.length;
      for (uint i = 0; i < len; i++) {
        if( epoch == epoches[i]) {
            if (i == len - 1) {
                epoches.pop();
                break;
            } else {
              epoches[i] = epoches[len - 1];
              epoches.pop();
              break;
            }
        }
      }
  }

  function init() external {
    require(address(farming) == address(0), "inited");
    farming = msg.sender;
  }

  function updateReward(address[] memory epochs, uint[] memory awards, uint periodFinish) public onlyFarming {
      if(periodFinish <= block.timestamp) {
        return ;
      }

      require(epochs.length == awards.length, "mismatch length");
      updatePool();

      periodEnd = periodFinish;
      uint duration = periodFinish - block.timestamp;
      
      for(uint256 i = 0; i< epochs.length; i++) { 
        addEpoch(epochs[i]);
        EpochInfo storage epinfo =  epochInfos[epochs[i]];
        epinfo.epochPerSecond = awards[i] / duration;
      }
  }

  function getPassed() internal view returns (uint) {
    uint endTs;
    if (periodEnd > block.timestamp) {
      endTs = block.timestamp;
    } else {
      endTs = periodEnd;
    }
    
    if (endTs <= lastRewardSecond) {
      return 0;
    }

    return endTs - lastRewardSecond;
  }

  function updatePool() internal {
    uint passed = getPassed();

    if (totalAmount > 0 && passed > 0) {
      for(uint256 i = 0; i< epoches.length; i++) { 
        EpochInfo storage epinfo = epochInfos[epoches[i]];
        epinfo.accPerShare += epinfo.epochPerSecond * passed * SCALE / totalAmount;
      }
    }
    lastRewardSecond = block.timestamp;
    
  }

  function updateUser(address user, uint newDeposit, bool liq) internal {
    
    for(uint256 i = 0; i< epoches.length; i++) { 
      EpochInfo memory epinfo =  epochInfos[epoches[i]];
      if (liq) {
        rewardAvailable[user][epoches[i]] = 0;
      } else {
        rewardAvailable[user][epoches[i]] += (deposits[user] * epinfo.accPerShare / SCALE) - rewardDebt[user][epoches[i]];
      }
      
      rewardDebt[user][epoches[i]] = newDeposit * epinfo.accPerShare / SCALE;
    }  
  }

  function deposit(address user, uint256 amount) external onlyFarming {
    updatePool();
    uint newDeposit = deposits[user] + amount;

    updateUser(user, newDeposit, false);
    deposits[user] = newDeposit;
    totalAmount += amount;

    emit Deposit(user, amount);
  }

  function withdraw(address user, uint256 amount) external onlyFarming {
    updatePool();
    
    uint newDeposit = deposits[user] - amount;
    updateUser(user, newDeposit, false);

    deposits[user] = newDeposit;
    totalAmount -= amount;
    emit Withdraw(user, amount);
  }

  function liquidate(address user) external onlyFarming {
    updatePool();

    updateUser(user,0, true);
    uint amount = deposits[user];
    totalAmount -= amount;
    deposits[user] = 0;
    emit Withdraw(user, amount);
  }

  function pending(address user) public view returns (address[] memory epochs, uint256[] memory rewards) {
    uint passed = getPassed();

    uint len = epoches.length;
    rewards = new uint[](len);
    
    for(uint256 i = 0; i< epoches.length; i++) {

      EpochInfo memory epinfo =  epochInfos[epoches[i]];
      uint currPending = 0;
      if (passed > 0) {
        currPending = epinfo.epochPerSecond * passed * deposits[user] / totalAmount;
      }
      rewards[i] = rewardAvailable[user][epoches[i]] 
        + currPending
        + (deposits[user] * epinfo.accPerShare / SCALE) - rewardDebt[user][epoches[i]];
    }

    epochs = epoches;
  }

  function withdrawAward(address user) external returns (address[] memory epochs, uint256[] memory rewards) {
    require(farming == msg.sender, "must call from framing");
    updatePool();
    updateUser(user, deposits[user], false);

    (epochs, rewards) = pending(user);

    for(uint256 i = 0; i< epoches.length; i++) {
      rewardAvailable[user][epoches[i]] = 0;
    }
  }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/CloneFactory.sol

pragma solidity >=0.8.0;


// introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/
// minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167

contract CloneFactory  {

    function createClone(address prototype) internal returns (address proxy) {
        bytes20 targetBytes = bytes20(prototype);
        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            proxy := create(0, clone, 0x37)
        }
        return proxy;
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Duet_Bond/duet-bond-contract-549f7d3a4973a918cb12059cc1ef3f2ace56d9bc/contracts/VaultFarm.sol

//SPDX-License-Identifier: MIT
pragma solidity 0.8.11;






contract VaultFarm is IVaultFarm, CloneFactory, OwnableUpgradeable {
  address public bond;
  address public poolImp;

  address[] public pools;
  // pool => point
  mapping(address => uint) public allocPoint;
  // asset => pool
  mapping(address => address) public assetPool;

  mapping(address => bool) public vaults;
  
  uint256 public totalAllocPoint;
  uint256 public lastUpdateSecond;
  uint256 public periodFinish;

  address[] public epoches;
  uint[] public epochRewards;

  event NewPool(address asset, address pool);
  event VaultApproved(address vault, bool approved);

  constructor() {
  }

  function initialize(address _bond, address _poolImp) external initializer {
    OwnableUpgradeable.__Ownable_init();
    bond = _bond;
    poolImp = _poolImp;
  }

  function setPoolImp(address _poolImp) external onlyOwner {
    poolImp = _poolImp;
  }

  function approveVault(address vault, bool approved)  external onlyOwner {
    vaults[vault] = approved;
    emit VaultApproved(vault, approved);
  }

  function assetPoolAlloc(address asset) external view returns (address pool, uint alloc){
    pool = assetPool[asset];
    alloc = allocPoint[pool];
  }

  function getPools() external view returns(address [] memory ps) {
    ps = pools;
  }

  function epochesRewards() external view returns(address[] memory epochs, uint[] memory rewards) {
    epochs = epoches;
    rewards = epochRewards;
  }

  function syncVault(address vault) external {
    require(vaults[vault], "invalid vault");
    address asset = IVault(vault).underlying();
    uint amount = IVault(vault).deposits(msg.sender);

    address pooladdr = assetPool[asset];
    require(pooladdr != address(0), "no asset pool");
    
    uint currAmount = Pool(pooladdr).deposits(msg.sender);
    require(amount != currAmount, "aleady migrated");

    if (amount > currAmount) {
      Pool(pooladdr).deposit(msg.sender, amount - currAmount);
    } else {
      Pool(pooladdr).withdraw(msg.sender, currAmount - amount);
    }
  }

  function syncDeposit(address _user, uint256 _amount, address asset) external override {
    require(vaults[msg.sender], "invalid vault");
    address pooladdr = assetPool[asset];
    if (pooladdr != address(0)) {
      Pool(pooladdr).deposit(_user, _amount);
    }
  }

  function syncWithdraw(address _user, uint256 _amount, address asset) external override {
    require(vaults[msg.sender], "invalid vault");
    address pooladdr = assetPool[asset];
    if (pooladdr != address(0)) {
      Pool(pooladdr).withdraw(_user, _amount);
    }
  }

  function syncLiquidate(address _user, address asset) external override {
    require(vaults[msg.sender], "invalid vault");
    address pooladdr = assetPool[asset];
    if (pooladdr != address(0)) {
      Pool(pooladdr).liquidate(_user);
    }
  }
  //SWC-Function Default Visibility: L111-L126
  function massUpdatePools(address[] memory epochs, uint256[] memory rewards) public {
    uint256 poolLen = pools.length;
    uint256 epochLen = epochs.length;
    

    uint[] memory epochArr = new uint[](epochLen);
    for (uint256 pi = 0; pi < poolLen; pi++) {
      for (uint256 ei = 0; ei < epochLen; ei++) {
        epochArr[ei] = rewards[ei] * allocPoint[pools[pi]] / totalAllocPoint;
      }
      Pool(pools[pi]).updateReward(epochs, epochArr, periodFinish);
    }

    epochRewards = rewards;
    lastUpdateSecond = block.timestamp;
  }

  // epochs need small for gas issue.
  function newReward(address[] memory epochs, uint256[] memory rewards, uint duration) public onlyOwner {
    require(block.timestamp >= periodFinish, 'period not finish');
    require(duration > 0, 'duration zero');

    periodFinish = block.timestamp + duration;
    epoches = epochs;
    massUpdatePools(epochs, rewards);
    
    for (uint i = 0 ; i < epochs.length; i++) {
      require(IEpoch(epochs[i]).bond() == bond, "invalid epoch");
      IERC20(epochs[i]).transferFrom(msg.sender, address(this), rewards[i]);
    }
  }

  function appendReward(address epoch, uint256 reward) public onlyOwner {
    require(block.timestamp < periodFinish, 'period not finish');
    require(IEpoch(epoch).bond() == bond, "invalid epoch");

    bool inEpoch;
    uint i;
    for (; i < epoches.length; i++) {
      if (epoch == epoches[i]) {
        inEpoch = true;
        break;
      }
    }

    uint[] memory leftRewards = calLeftAwards();
    if (!inEpoch) {
      epoches.push(epoch);
      uint[] memory newleftRewards = new uint[](epoches.length);
      for (uint j = 0; j < leftRewards.length; j++) {
        newleftRewards[j] = leftRewards[j];
      }
      newleftRewards[leftRewards.length] = reward;
      
      massUpdatePools(epoches, newleftRewards);
    } else {
      leftRewards[i] += reward;
      massUpdatePools(epoches, leftRewards);
    }

    IERC20(epoch).transferFrom(msg.sender, address(this), reward);
  }

  function removePoolEpoch(address pool, address epoch) external onlyOwner {
    Pool(pool).remove(epoch);
  }

  function calLeftAwards() internal view  returns(uint[] memory leftRewards) {
    uint len = epochRewards.length;
    leftRewards = new uint[](len);
    if (periodFinish > lastUpdateSecond && block.timestamp < periodFinish) {
      uint duration = periodFinish - lastUpdateSecond;
      uint passed = block.timestamp - lastUpdateSecond;

      for (uint i = 0 ; i < len; i++) {
        leftRewards[i] = epochRewards[i] - (passed *  epochRewards[i] / duration);
      }
    }
  }

  function newPool(uint256 _allocPoint, address asset) public onlyOwner {
    require(assetPool[asset] == address(0), "pool exist!");

    address pool = createClone(poolImp);
    Pool(pool).init();

    pools.push(pool);
    allocPoint[pool] = _allocPoint;
    assetPool[asset] = pool;
    totalAllocPoint = totalAllocPoint + _allocPoint;

    emit NewPool(asset, pool);
    uint[] memory leftRewards = calLeftAwards();
    massUpdatePools(epoches,leftRewards);
  }

  function updatePool(uint256 _allocPoint, address asset) public onlyOwner {
    address pool = assetPool[asset];
    require(pool != address(0), "pool not exist!");

    totalAllocPoint = totalAllocPoint - allocPoint[pool] + _allocPoint;
    allocPoint[pool] = _allocPoint;

    uint[] memory leftRewards = calLeftAwards();
    massUpdatePools(epoches,leftRewards);
  }

  // _pools need small for gas issue.
  function withdrawAward(address[] memory _pools, address to, bool redeem) external {
    address user = msg.sender;

    uint len = _pools.length;
    address[] memory epochs;
    uint256[] memory rewards;
    for (uint i = 0 ; i < len; i++) {
      (epochs, rewards)= Pool(_pools[i]).withdrawAward(user);
      if (redeem) {
        ISingleBond(bond).redeemOrTransfer(epochs, rewards, to);
      } else {
        ISingleBond(bond).multiTransfer(epochs, rewards, to);
      }
    }
  }

  function redeemAward(address[] memory _pools, address to) external {
    address user = msg.sender;

    uint len = _pools.length;
    address[] memory epochs;
    uint256[] memory rewards;
    for (uint i = 0 ; i < len; i++) {
      (epochs, rewards)= Pool(_pools[i]).withdrawAward(user);
      ISingleBond(bond).redeem(epochs, rewards, to);
    }
  }

  function emergencyWithdraw(address[] memory epochs, uint256[] memory amounts) external onlyOwner {
    require(epochs.length == amounts.length, "mismatch length");
    for (uint i = 0 ; i < epochs.length; i++) {
      IERC20(epochs[i]).transfer(msg.sender, amounts[i]);
    }
  }
}
