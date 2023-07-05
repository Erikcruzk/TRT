// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/types/DataTypes.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

library DataTypes {

  struct InstrumentData {

    InstrumentConfigurationMap configuration;      //stores the instrument configuration
    uint128 liquidityIndex;                     //the liquidity index. Expressed in ray
    uint128 variableBorrowIndex;                //variable borrow index. Expressed in ray

    uint128 currentLiquidityRate;               //the current supply rate. Expressed in ray
    uint128 currentVariableBorrowRate;          //the current variable borrow rate. Expressed in ray
    uint128 currentStableBorrowRate;            //the current stable borrow rate. Expressed in ray

    uint40 lastUpdateTimestamp;

    address iTokenAddress;                      //tokens addresses
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;

    address interestRateStrategyAddress;        //address of the interest rate strategy

    uint8 id;                                   //the id of the instrument. Represents the position in the list of the active instruments
    uint8 decimals;
  }

  struct InstrumentConfigurationMap {
    //bit 0-15: LTV
    //bit 16-31: Liq. threshold
    //bit 32-47: Liq. bonus
    //bit 48-55: Decimals
    //bit 56: Reserve is active
    //bit 57: reserve is frozen
    //bit 58: borrowing is enabled
    //bit 59: stable rate borrowing enabled
    //bit 60-63: reserved
    //bit 64-79: reserve factor
    uint256 data;
  }

  struct UserConfigurationMap {
    uint256 data;
  }

  enum InterestRateMode {NONE, STABLE, VARIABLE}
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IFeeProvider.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
* @title FeeProvider contract Interface
* @notice Implements calculation for the fees applied by the protocol based on the Boosters
* @author SIGH Finance (_astromartian)
**/
interface IFeeProvider  {

    event depositFeePercentUpdated(uint _depositFeePercent);
    event borrowFeePercentUpdated(uint totalBorrowFeePercent_);
    event flashLoanFeePercentUpdated(uint totalFlashLoanFeePercent_);
    event platformFeePercentUpdated(uint _platformFeePercent);

    event initalFuelForABoosterCategoryUpdated(string categoryName,uint initialFuel);
    event topUpOptionUpdated(string category, uint optionNo,uint _fee, uint _multiplier);
    event tokenForPaymentUpdated(address prevToken,address tokenAccepted);
    event tokensTransferred(address token, address destination, uint amount,uint newBalance );

    event _boosterTopUp( uint boosterID,uint optionNo,uint amount,uint topUp,uint totalFuelRemaining);


// ###############################
// ###### PROXY RELATED ##########
// ###############################

    function refreshConfiguration() external returns (bool);

// ###############################################################################################
// ###### EXTERNAL FUNCTIONS TO CALCULATE THE FEE (Can only be called by LendingPool) ############
// ###### 1. calculateDepositFee() ##########
// ###### 2. calculateFlashLoanFee() #######################################
// ###### 1. calculateBorrowFee() ##########
// ################################################################################################

    function calculateDepositFee(address _user,address instrument, uint256 _amount, uint boosterId) external returns (uint256 ,uint256 ,uint256 );
    function calculateBorrowFee(address _user, address instrument, uint256 _amount, uint boosterId) external returns (uint256 platformFee, uint256 reserveFee) ;
    function calculateFlashLoanFee(address _user, uint256 _amount, uint boosterId) external view returns (uint256 ,uint256 ,uint256 ) ;


// #################################
// ####### FUNCTIONS TO INCREASE FUEL LIMIT  ########
// #################################

    function fuelTopUp(uint optionNo, uint boosterID) external ;


// #################################
// ####### ADMIN FUNCTIONS  ########
// #################################

    function updateTotalDepositFeePercent(uint _depositFeePercent) external returns (bool) ;
    function updateTotalBorrowFeePercent(uint totalBorrowFeePercent_) external returns (bool) ;
    function updateTotalFlashLoanFeePercent(uint totalFlashLoanFeePercent_ ) external returns (bool) ;
    function updatePlatformFeePercent(uint _platformFeePercent) external returns (bool);

    function UpdateABoosterCategoryFuelAmount(string calldata categoryName, uint initialFuel ) external returns (bool);
    function updateATopUpOption(string calldata category, uint optionNo, uint _fee, uint _multiplier) external returns (bool) ;

    function updateTokenAccepted(address _token) external  returns (bool) ;
    function transferFunds(address token, address destination, uint amount) external returns (bool) ;

// ###############################
// ####### EXTERNAL VIEW  ########
// ###############################

    function getBorrowFeePercentage() external view returns (uint256) ;
    function getDepositFeePercentage() external view returns (uint256) ;
    function getFlashLoanFeePercentage() external view returns (uint256) ;

    function getFuelAvailable(uint boosterID) external view returns (uint256) ;
    function getFuelUsed(uint boosterID) external view returns (uint256) ;
    function getOptionDetails(string calldata category, uint optionNo) external view returns (uint fee, uint multiplier) ;

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/helpers/Helpers.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;



/**
 * @title Helpers library
 * @author Aave
 */
library Helpers {

  /**
   * @dev Fetches the user current stable and variable debt balances
   * @param user The user address
   * @param instrument The instrument data object
   * @return The stable and variable debt balance
   **/
  function getUserCurrentDebt(address user, DataTypes.InstrumentData storage instrument) internal view returns (uint256, uint256) {
    return ( IERC20(instrument.stableDebtTokenAddress).balanceOf(user), IERC20(instrument.variableDebtTokenAddress).balanceOf(user) );
  }

  function getUserCurrentDebtMemory(address user, DataTypes.InstrumentData memory instrument) internal view returns (uint256, uint256) {
    return ( IERC20(instrument.stableDebtTokenAddress).balanceOf(user), IERC20(instrument.variableDebtTokenAddress).balanceOf(user) );
  }


}
