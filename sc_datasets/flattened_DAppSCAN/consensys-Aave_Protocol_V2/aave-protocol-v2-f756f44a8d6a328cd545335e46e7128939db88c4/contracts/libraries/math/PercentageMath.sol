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

// File: ../sc_datasets/DAppSCAN/consensys-Aave_Protocol_V2/aave-protocol-v2-f756f44a8d6a328cd545335e46e7128939db88c4/contracts/libraries/math/PercentageMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;

/**
 * @title PercentageMath library
 * @author Aave
 * @notice Provides functions to calculate percentages.
 * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
 * @dev Operations are rounded half up
 **/

library PercentageMath {
  uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
  uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;

  /**
   * @dev executes a percentage multiplication
   * @param value the value of which the percentage needs to be calculated
   * @param percentage the percentage of the value to be calculated
   * @return the percentage of value
   **/
  function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
    if (value == 0) {
      return 0;
    }

    uint256 result = value * percentage;

    require(result / value == percentage, Errors.MULTIPLICATION_OVERFLOW);

    result += HALF_PERCENT;

    require(result >= HALF_PERCENT, Errors.ADDITION_OVERFLOW);

    return result / PERCENTAGE_FACTOR;
  }

  /**
   * @dev executes a percentage division
   * @param value the value of which the percentage needs to be calculated
   * @param percentage the percentage of the value to be calculated
   * @return the value divided the percentage
   **/
  function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
    require(percentage != 0, Errors.DIVISION_BY_ZERO);
    uint256 halfPercentage = percentage / 2;

    uint256 result = value * PERCENTAGE_FACTOR;

    require(result / PERCENTAGE_FACTOR == value, Errors.MULTIPLICATION_OVERFLOW);

    result += halfPercentage;

    require(result >= halfPercentage, Errors.ADDITION_OVERFLOW);

    return result / percentage;
  }
}
