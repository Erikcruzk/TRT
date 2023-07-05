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

// File: @openzeppelin/contracts/utils/Address.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)

pragma solidity ^0.8.1;

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

// File: @openzeppelin/contracts/proxy/utils/Initializable.sol

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
            (isTopLevelCall && _initialized < 1) || (!Address.isContract(address(this)) && _initialized == 1),
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

// File: ../sc_datasets/DAppSCAN/QuillAudits-MetaGameStarter Smart Contract/Tokenomics-Contracts-f3899d0a31dbb7386eacb7efefbff2ac32ce7cbb/contracts/ProxyClones/ContextForClones.sol

// SPDX-License-Identifier: MIT

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
abstract contract ContextForClones is Initializable {
    function __Context_init() internal initializer {
        __Context_init_unchained();
    }

    function __Context_init_unchained() internal initializer {
    }
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
    uint256[50] private __gap;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-MetaGameStarter Smart Contract/Tokenomics-Contracts-f3899d0a31dbb7386eacb7efefbff2ac32ce7cbb/contracts/ProxyClones/OwnableForClones.sol

// SPDX-License-Identifier: MIT

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
abstract contract OwnableForClones is ContextForClones {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    function __Ownable_init() internal initializer {
        __Ownable_init_unchained();
    }

    function __Ownable_init_unchained() internal initializer {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-MetaGameStarter Smart Contract/Tokenomics-Contracts-f3899d0a31dbb7386eacb7efefbff2ac32ce7cbb/contracts/IFO/AggregatorV3Interface.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
  );

}

// File: ../sc_datasets/DAppSCAN/QuillAudits-MetaGameStarter Smart Contract/Tokenomics-Contracts-f3899d0a31dbb7386eacb7efefbff2ac32ce7cbb/contracts/IFO/FixPrice.sol

// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;



/**

    ✩░▒▓▆▅▃▂▁𝐌𝐞𝐭𝐚𝐆𝐚𝐦𝐞𝐇𝐮𝐛▁▂▃▅▆▓▒░✩

*/


contract MGHPublicOffering is OwnableForClones {

  // chainlink impl. to get any kind of pricefeed
  AggregatorV3Interface internal priceFeed;

  // The LP token used
  IERC20 public lpToken;

  // The offering token
  IERC20 public offeringToken;

  // The block number when IFO starts
  uint256 public startBlock;

  // The block number when IFO ends
  uint256 public endBlock;

  //after this block harvesting is possible
  uint256 private harvestBlock;

  // maps the user-address to the deposited amount in that Pool
  mapping(address => uint256) private amount;

  // amount of tokens offered for the pool (in offeringTokens)
  uint256 private offeringAmount;

  // price in MGH/USDT => for 1 MGH/USDT price would be 10**12; 10MGH/USDT would be 10**13
  uint256 private _price;

  // total amount deposited in the Pool (in LP tokens); resets when new Start and EndBlock are set
  uint256 private totalAmount;

  // Admin withdraw event
  event AdminWithdraw(uint256 amountLP, uint256 amountOfferingToken, uint256 amountWei);

  // Admin recovers token
  event AdminTokenRecovery(address tokenAddress, uint256 amountTokens);

  // Deposit event
  event Deposit(address indexed user, uint256 amount);

  // Harvest event
  event Harvest(address indexed user, uint256 offeringAmount);

  // Event for new start & end blocks
  event NewStartAndEndBlocks(uint256 startBlock, uint256 endBlock);

  // parameters are set for the pool
  event PoolParametersSet(uint256 offeringAmount, uint256 price);

  // timeLock ensures that users have enough time to harvest before Admin withdraws tokens,
  // sets new Start and EndBlocks or changes Pool specifications
  modifier timeLock() {
    require(block.number > harvestBlock, "admin must wait before calling this function");
    _;
  }

  /**
    * @dev It can only be called once.
    * @param _lpToken the LP token used
    * @param _offeringToken the token that is offered for the IFO
    * @param _offeringAmount amount without decimals
    * @param __price the price in OfferingToken/LPToken adjusted already by 6 decimal places
    * @param _startBlock start of sale time
    * @param _endBlock end of sale time
    * @param _harvestBlock start of harvest time
    * @param _adminAddress the admin address
  */
  function initialize(
    address _lpToken,
    address _offeringToken,
    address _priceFeed,
    address _adminAddress,
    uint256 _offeringAmount,
    uint256 __price,
    uint256 _startBlock,
    uint256 _endBlock,
    uint256 _harvestBlock
    )
    external initializer
    {
    __Ownable_init();
    lpToken = IERC20(_lpToken);
    offeringToken = IERC20(_offeringToken);
    priceFeed = AggregatorV3Interface(_priceFeed);
    setPool(_offeringAmount*10**18, __price*10**6);
    updateStartAndEndBlocks(_startBlock, _endBlock, _harvestBlock);
    transferOwnership(_adminAddress);
  }

  /**
    * @notice It allows users to deposit LP tokens opr ether to pool
    * @param _amount: the number of LP token used (6 decimals)
  */
  function deposit(uint256 _amount) external payable {

    // Checks whether the block number is not too early
    require(block.number > startBlock && block.number < endBlock, "Not sale time");

    // Transfers funds to this contract
    if (_amount > 0) {
      require(lpToken.transferFrom(address(msg.sender), address(this), _amount));
  	}
    // Updates the totalAmount for pool
    if (msg.value > 0) {
      _amount += uint256(getLatestEthPrice()) * msg.value / 1e20;
    }
    totalAmount += _amount;

    // if its pool1, check if new total amount will be smaller or equal to OfferingAmount / price
    require(
      offeringAmount >= totalAmount * _price,
      "not enough tokens left"
    );

    // Update the user status
    amount[msg.sender] += _amount;

    emit Deposit(msg.sender, _amount);
  }

  /**
    * @notice It allows users to harvest from pool
    * @notice if user is not whitelisted and the whitelist is active, the user is refunded in lpTokens
  */
  function harvest() external {
    // buffer time between end of deposit and start of harvest for admin to whitelist (~7 hours)
    require(block.number > harvestBlock, "Too early to harvest");

    // Checks whether the user has participated
    require(amount[msg.sender] > 0, "already harvested");

    // Initialize the variables for offering and refunding user amounts
    uint256 offeringTokenAmount = _calculateOfferingAmount(msg.sender);

    amount[msg.sender] = 0;

    require(offeringToken.transfer(address(msg.sender), offeringTokenAmount));

    emit Harvest(msg.sender, offeringTokenAmount);
  }


  /**
    * @notice It allows the admin to withdraw funds
    * @notice the offering token can only be withdrawn 10000 blocks after harvesting
    * @param _lpAmount: the number of LP token to withdraw (18 decimals)
    * @param _offerAmount: the number of offering amount to withdraw
    * @param _weiAmount: the amount of Wei to withdraw
    * @dev This function is only callable by admin.
  */
  function finalWithdraw(uint256 _lpAmount, uint256 _offerAmount, uint256 _weiAmount) external  onlyOwner {

    if (_lpAmount > 0) {
      lpToken.transfer(address(msg.sender), _lpAmount);
    }

    if (_offerAmount > 0) {
      require(block.number > harvestBlock + 10000, "too early to withdraw offering token");
      offeringToken.transfer(address(msg.sender), _offerAmount);
    }

    if (_weiAmount > 0) {
      payable(address(msg.sender)).transfer(_weiAmount);
    }

    emit AdminWithdraw(_lpAmount, _offerAmount, _weiAmount);
  }

  /**
    * @notice It allows the admin to recover wrong tokens sent to the contract
    * @param _tokenAddress: the address of the token to withdraw (18 decimals)
    * @param _tokenAmount: the number of token amount to withdraw
    * @dev This function is only callable by admin.
  */
  function recoverWrongTokens(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
    require(_tokenAddress != address(lpToken), "Cannot be LP token");
    require(_tokenAddress != address(offeringToken), "Cannot be offering token");

    IERC20(_tokenAddress).transfer(address(msg.sender), _tokenAmount);

    emit AdminTokenRecovery(_tokenAddress, _tokenAmount);
  }

  /**
    * @notice timeLock
    * @notice It sets parameters for pool
    * @param _offeringAmount offering amount with all decimals
    * @dev This function is only callable by admin
  */
  function setPool(
    uint256 _offeringAmount,
    uint256 __price
   ) public onlyOwner timeLock
   {
    offeringAmount = _offeringAmount;
    _price = __price;
    emit PoolParametersSet(_offeringAmount, _price);
  }

  /**
    * @notice It allows the admin to update start and end blocks
    * @notice automatically resets the totalAmount in the Pool to 0, but not userAmounts
    * @notice timeLock
    * @param _startBlock: the new start block
    * @param _endBlock: the new end block
  */
  function updateStartAndEndBlocks(uint256 _startBlock, uint256 _endBlock, uint256 _harvestBlock) public onlyOwner timeLock {
    require(_startBlock < _endBlock, "New startBlock must be lower than new endBlock");
    require(block.number < _startBlock, "New startBlock must be higher than current block");
    totalAmount = 0;
    startBlock = _startBlock;
    endBlock = _endBlock;
    harvestBlock = _harvestBlock;

    emit NewStartAndEndBlocks(_startBlock, _endBlock);
  }

  /**
    * @notice It returns the pool information
    * @return offeringAmountPool: amount of tokens offered for the pool (in offeringTokens)
    * @return _price the price in OfferingToken/LPToken, 10**12 means 1:1 because of different decimal places
    * @return totalAmountPool: total amount pool deposited (in LP tokens)
  */
  function viewPoolInformation()
    external
    view
    returns(
      uint256,
      uint256,
      uint256
    )
    {
    return (
      offeringAmount,
      _price,
      totalAmount
    );
  }

  /**
    * @notice External view function to see user amount in pool
    * @param _user: user address
  */
  function viewUserAmount(address _user)
    external
    view
    returns(uint256)
  {
    return (amount[_user]);
  }

  /**
    * @notice External view function to see user offering amounts
    * @param _user: user address
  */
  function viewUserOfferingAmount(address _user)
    external
    view
    returns(uint256)
  {
    return _calculateOfferingAmount(_user);
  }

  /**
    * @notice It calculates the offering amount for a user and the number of LP tokens to transfer back.
    * @param _user: user address
    * @return the amount of OfferingTokens _user receives as of now
  */
  function _calculateOfferingAmount(address _user)
    internal
    view
    returns(uint256)
  {
    return amount[_user] * _price;
  }

  function setToken(address _lpToken, address _offering) public onlyOwner timeLock {
    lpToken = IERC20(_lpToken);
    offeringToken = IERC20(_offering);
  }

  /**
    * @return returns the price from the AggregatorV3 contract specified in initialization 
  */
  function getLatestEthPrice() public view returns(int) {
    (
      uint80 roundID,
      int price,
      uint startedAt,
      uint timeStamp,
      uint80 answeredInRound
    ) = priceFeed.latestRoundData();
    return price;
  }
}
