// File: @openzeppelin/contracts/utils/Context.sol

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
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
}

// File: ../sc_datasets/DAppSCAN/consensys-Aave_Protocol_V2/aave-protocol-v2-f756f44a8d6a328cd545335e46e7128939db88c4/contracts/interfaces/ILendingPoolAddressesProviderRegistry.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;

/**
 * @title ILendingPoolAddressesProvider interface
 * @notice provides the interface to fetch the LendingPoolCore address
 **/

interface ILendingPoolAddressesProviderRegistry {
  //events
  event AddressesProviderRegistered(address indexed newAddress);
  event AddressesProviderUnregistered(address indexed newAddress);

  function getAddressesProvidersList() external view returns (address[] memory);

  function isAddressesProviderRegistered(address provider) external view returns (uint256);

  function registerAddressesProvider(address provider, uint256 id) external;

  function unregisterAddressesProvider(address provider) external;
}

// File: ../sc_datasets/DAppSCAN/consensys-Aave_Protocol_V2/aave-protocol-v2-f756f44a8d6a328cd545335e46e7128939db88c4/contracts/libraries/helpers/Errors.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;

/**
 * @title Errors library
 * @author Aave
 * @notice Implements error messages.
 */
library Errors {
  // require error messages - ValidationLogic
  string public constant AMOUNT_NOT_GREATER_THAN_0 = '1'; // 'Amount must be greater than 0'
  string public constant NO_ACTIVE_RESERVE = '2'; // 'Action requires an active reserve'
  string public constant NO_UNFREEZED_RESERVE = '3'; // 'Action requires an unfreezed reserve'
  string public constant CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = '4'; // 'The current liquidity is not enough'
  string public constant NOT_ENOUGH_AVAILABLE_USER_BALANCE = '5'; // 'User cannot withdraw more than the available balance'
  string public constant TRANSFER_NOT_ALLOWED = '6'; // 'Transfer cannot be allowed.'
  string public constant BORROWING_NOT_ENABLED = '7'; // 'Borrowing is not enabled'
  string public constant INVALID_INTEREST_RATE_MODE_SELECTED = '8'; // 'Invalid interest rate mode selected'
  string public constant COLLATERAL_BALANCE_IS_0 = '9'; // 'The collateral balance is 0'
  string public constant HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = '10'; // 'Health factor is lesser than the liquidation threshold'
  string public constant COLLATERAL_CANNOT_COVER_NEW_BORROW = '11'; // 'There is not enough collateral to cover a new borrow'
  string public constant STABLE_BORROWING_NOT_ENABLED = '12'; // stable borrowing not enabled
  string public constant CALLATERAL_SAME_AS_BORROWING_CURRENCY = '13'; // collateral is (mostly) the same currency that is being borrowed
  string public constant AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = '14'; // 'The requested amount is greater than the max loan size in stable rate mode
  string public constant NO_DEBT_OF_SELECTED_TYPE = '15'; // 'for repayment of stable debt, the user needs to have stable debt, otherwise, he needs to have variable debt'
  string public constant NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = '16'; // 'To repay on behalf of an user an explicit amount to repay is needed'
  string public constant NO_STABLE_RATE_LOAN_IN_RESERVE = '17'; // 'User does not have a stable rate loan in progress on this reserve'
  string public constant NO_VARIABLE_RATE_LOAN_IN_RESERVE = '18'; // 'User does not have a variable rate loan in progress on this reserve'
  string public constant UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = '19'; // 'The underlying balance needs to be greater than 0'
  string public constant DEPOSIT_ALREADY_IN_USE = '20'; // 'User deposit is already being used as collateral'

  // require error messages - LendingPool
  string public constant NOT_ENOUGH_STABLE_BORROW_BALANCE = '21'; // 'User does not have any stable rate loan for this reserve'
  string public constant INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = '22'; // 'Interest rate rebalance conditions were not met'
  string public constant LIQUIDATION_CALL_FAILED = '23'; // 'Liquidation call failed'
  string public constant NOT_ENOUGH_LIQUIDITY_TO_BORROW = '24'; // 'There is not enough liquidity available to borrow'
  string public constant REQUESTED_AMOUNT_TOO_SMALL = '25'; // 'The requested amount is too small for a FlashLoan.'
  string public constant INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = '26'; // 'The actual balance of the protocol is inconsistent'
  string public constant CALLER_NOT_LENDING_POOL_CONFIGURATOR = '27'; // 'The actual balance of the protocol is inconsistent'
  string public constant INVALID_FLASHLOAN_MODE = '43'; //Invalid flashloan mode selected
  string public constant BORROW_ALLOWANCE_ARE_NOT_ENOUGH = '54'; // User borrows on behalf, but allowance are too small
  string public constant REENTRANCY_NOT_ALLOWED = '57';
  string public constant FAILED_REPAY_WITH_COLLATERAL = '53';
  string public constant FAILED_COLLATERAL_SWAP = '55';
  string public constant INVALID_EQUAL_ASSETS_TO_SWAP = '56';
  string public constant NO_MORE_RESERVES_ALLOWED = '59';

  // require error messages - aToken
  string public constant CALLER_MUST_BE_LENDING_POOL = '28'; // 'The caller of this function must be a lending pool'
  string public constant CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = '30'; // 'User cannot give allowance to himself'
  string public constant TRANSFER_AMOUNT_NOT_GT_0 = '31'; // 'Transferred amount needs to be greater than zero'

  // require error messages - ReserveLogic
  string public constant RESERVE_ALREADY_INITIALIZED = '34'; // 'Reserve has already been initialized'
  string public constant LIQUIDITY_INDEX_OVERFLOW = '47'; //  Liquidity index overflows uint128
  string public constant VARIABLE_BORROW_INDEX_OVERFLOW = '48'; //  Variable borrow index overflows uint128
  string public constant LIQUIDITY_RATE_OVERFLOW = '49'; //  Liquidity rate overflows uint128
  string public constant VARIABLE_BORROW_RATE_OVERFLOW = '50'; //  Variable borrow rate overflows uint128
  string public constant STABLE_BORROW_RATE_OVERFLOW = '51'; //  Stable borrow rate overflows uint128

  //require error messages - LendingPoolConfiguration
  string public constant CALLER_NOT_AAVE_ADMIN = '35'; // 'The caller must be the aave admin'
  string public constant RESERVE_LIQUIDITY_NOT_0 = '36'; // 'The liquidity of the reserve needs to be 0'

  //require error messages - LendingPoolAddressesProviderRegistry
  string public constant PROVIDER_NOT_REGISTERED = '37'; // 'Provider is not registered'

  //return error messages - LendingPoolCollateralManager
  string public constant HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '38'; // 'Health factor is not below the threshold'
  string public constant COLLATERAL_CANNOT_BE_LIQUIDATED = '39'; // 'The collateral chosen cannot be liquidated'
  string public constant SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '40'; // 'User did not borrow the specified currency'
  string public constant NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '41'; // "There isn't enough liquidity available to liquidate"
  string public constant NO_ERRORS = '42'; // 'No errors'

  //require error messages - Math libraries
  string public constant MULTIPLICATION_OVERFLOW = '44';
  string public constant ADDITION_OVERFLOW = '45';
  string public constant DIVISION_BY_ZERO = '46';

  // pausable error message
  string public constant IS_PAUSED = '58'; // 'Pool is paused'
  enum CollateralManagerErrors {
    NO_ERROR,
    NO_COLLATERAL_AVAILABLE,
    COLLATERAL_CANNOT_BE_LIQUIDATED,
    CURRRENCY_NOT_BORROWED,
    HEALTH_FACTOR_ABOVE_THRESHOLD,
    NOT_ENOUGH_LIQUIDITY,
    NO_ACTIVE_RESERVE,
    HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
    INVALID_EQUAL_ASSETS_TO_SWAP,
    NO_UNFREEZED_RESERVE
  }
}

// File: ../sc_datasets/DAppSCAN/consensys-Aave_Protocol_V2/aave-protocol-v2-f756f44a8d6a328cd545335e46e7128939db88c4/contracts/configuration/LendingPoolAddressesProviderRegistry.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;



/**
 * @title LendingPoolAddressesProviderRegistry contract
 * @notice contains the list of active addresses providers
 * @author Aave
 **/

contract LendingPoolAddressesProviderRegistry is Ownable, ILendingPoolAddressesProviderRegistry {
  mapping(address => uint256) addressesProviders;
  address[] addressesProvidersList;

  /**
   * @dev returns if an addressesProvider is registered or not
   * @param provider the addresses provider
   * @return true if the addressesProvider is registered, false otherwise
   **/
  function isAddressesProviderRegistered(address provider)
    external
    override
    view
    returns (uint256)
  {
    return addressesProviders[provider];
  }

  /**
   * @dev returns the list of active addressesProviders
   * @return the list of addressesProviders
   **/
  function getAddressesProvidersList() external override view returns (address[] memory) {
    uint256 maxLength = addressesProvidersList.length;

    address[] memory activeProviders = new address[](maxLength);

    for (uint256 i = 0; i < addressesProvidersList.length; i++) {
      if (addressesProviders[addressesProvidersList[i]] > 0) {
        activeProviders[i] = addressesProvidersList[i];
      }
    }

    return activeProviders;
  }

  /**
   * @dev adds a lending pool to the list of registered lending pools
   * @param provider the pool address to be registered
   **/
  function registerAddressesProvider(address provider, uint256 id) external override onlyOwner {
    addressesProviders[provider] = id;
    _addToAddressesProvidersList(provider);
    emit AddressesProviderRegistered(provider);
  }

  /**
   * @dev removes a lending pool from the list of registered lending pools
   * @param provider the pool address to be unregistered
   **/
  function unregisterAddressesProvider(address provider) external override onlyOwner {
    require(addressesProviders[provider] > 0, Errors.PROVIDER_NOT_REGISTERED);
    addressesProviders[provider] = 0;
    emit AddressesProviderUnregistered(provider);
  }

  /**
   * @dev adds to the list of the addresses providers, if it wasn't already added before
   * @param provider the pool address to be added
   **/
  function _addToAddressesProvidersList(address provider) internal {
    for (uint256 i = 0; i < addressesProvidersList.length; i++) {
      if (addressesProvidersList[i] == provider) {
        return;
      }
    }

    addressesProvidersList.push(provider);
  }
}
