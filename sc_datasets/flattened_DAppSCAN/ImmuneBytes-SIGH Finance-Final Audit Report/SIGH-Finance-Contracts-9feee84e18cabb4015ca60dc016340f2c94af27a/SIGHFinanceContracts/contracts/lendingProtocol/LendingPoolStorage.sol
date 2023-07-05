// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/GlobalAddressesProvider/IGlobalAddressesProvider.sol

// SPDX-License-Identifier: agpl-3.0

pragma solidity ^0.7.0;

/**
@title GlobalAddressesProvider interface
@notice provides the interface to fetch the LendingPoolCore address
 */

interface IGlobalAddressesProvider  {

// ########################################################################################
// #########  PROTOCOL MANAGERS ( LendingPool Manager and SighFinance Manager ) ###########
// ########################################################################################

    function getLendingPoolManager() external view returns (address);
    function getPendingLendingPoolManager() external view returns (address);

    function setPendingLendingPoolManager(address _pendinglendingPoolManager) external;
    function acceptLendingPoolManager() external;

    function getSIGHFinanceManager() external view returns (address);
    function getPendingSIGHFinanceManager() external view returns (address);

    function setPendingSIGHFinanceManager(address _PendingSIGHFinanceManager) external;
    function acceptSIGHFinanceManager() external;

// #########################################################################
// ####___________ LENDING POOL PROTOCOL CONTRACTS _____________############
// ########## 1. LendingPoolConfigurator (Upgradagble) #####################
// ########## 2. LendingPoolCore (Upgradagble) #############################
// ########## 3. LendingPool (Upgradagble) #################################
// ########## 4. LendingPoolDataProvider (Upgradagble) #####################
// ########## 5. LendingPoolParametersProvider (Upgradagble) ###############
// ########## 6. FeeProvider (Upgradagble) #################################
// ########## 7. LendingPoolLiqAndLoanManager (Directly Changed) ##########
// ########## 8. LendingRateOracle (Directly Changed) ######################
// #########################################################################

    function getLendingPoolConfigurator() external view returns (address);
    function setLendingPoolConfiguratorImpl(address _configurator) external;

    function getLendingPool() external view returns (address);
    function setLendingPoolImpl(address _pool) external;

    function getFeeProvider() external view returns (address);
    function setFeeProviderImpl(address _feeProvider) external;

    function getLendingPoolLiqAndLoanManager() external view returns (address);
    function setLendingPoolLiqAndLoanManager(address _manager) external;

    function getLendingRateOracle() external view returns (address);
    function setLendingRateOracle(address _lendingRateOracle) external;

// ####################################################################################
// ####___________ SIGH FINANCE RELATED CONTRACTS _____________########################
// ########## 1. SIGH (Initialized only once) #########################################
// ########## 2. SIGH Finance Configurator (Upgradagble) ################################
// ########## 2. SIGH Speed Controller (Initialized only once) ########################
// ########## 3. SIGH Treasury (Upgradagble) ###########################################
// ########## 4. SIGH Mechanism Handler (Upgradagble) ###################################
// ########## 5. SIGH Staking (Upgradagble) ###################################
// ####################################################################################

    function getSIGHAddress() external view returns (address);
    function setSIGHAddress(address sighAddress) external;

    function getSIGHNFTBoosters() external view returns (address) ;
    function setSIGHNFTBoosters(address _SIGHNFTBooster) external ;

    function getSIGHFinanceConfigurator() external view returns (address);
    function setSIGHFinanceConfiguratorImpl(address sighAddress) external;

    function getSIGHSpeedController() external view returns (address);
    function setSIGHSpeedController(address _SIGHSpeedController) external;

    function getSIGHTreasury() external view returns (address);                                 //  ADDED FOR SIGH FINANCE
    function setSIGHTreasuryImpl(address _SIGHTreasury) external;                                   //  ADDED FOR SIGH FINANCE

    function getSIGHVolatilityHarvester() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHVolatilityHarvesterImpl(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

    function getSIGHStaking() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHStaking(address _SIGHVolatilityHarvester) external;             //  ADDED FOR SIGH FINANCE

// #######################################################
// ####___________ PRICE ORACLE CONTRACT _____________####
// ####_____ SIGH FINANCE FEE COLLECTOR : ADDRESS ____####
// ####_____   SIGH PAYCOLLECTOR : ADDRESS        ____####
// #######################################################

    function getPriceOracle() external view returns (address);
    function setPriceOracle(address _priceOracle) external;


    // SIGH FINANCE FEE COLLECTOR - DEPOSIT / BORROWING / FLASH LOAN FEE TRANSERRED TO THIS ADDRESS
    function getSIGHFinanceFeeCollector() external view returns (address) ;
    function setSIGHFinanceFeeCollector(address _feeCollector) external ;

    function getSIGHPAYAggregator() external view returns (address);                      //  ADDED FOR SIGH FINANCE
    function setSIGHPAYAggregator(address _SIGHPAYAggregator) external;             //  ADDED FOR SIGH FINANCE

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/types/DataTypes.sol

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/configuration/UserConfiguration.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title UserConfiguration library
 * @author Aave
 * @notice Implements the bitmap logic to handle the user configuration
 */
library UserConfiguration {
  uint256 internal constant BORROWING_MASK = 0x5555555555555555555555555555555555555555555555555555555555555555;

  /**
   * @dev Sets if the user is borrowing the instrument identified by instrumentIndex
   * @param self The configuration object
   * @param instrumentIndex The index of the instrument in the bitmap
   * @param borrowing True if the user is borrowing the instrument, false otherwise
   **/
  function setBorrowing(DataTypes.UserConfigurationMap storage self, uint256 instrumentIndex, bool borrowing) internal {
    require(instrumentIndex < 128,"Invalid instrument Index");
    self.data = (self.data & ~(1 << (instrumentIndex * 2))) | (uint256(borrowing ? 1 : 0) << (instrumentIndex * 2));
  }

  /**
   * @dev Sets if the user is using as collateral the instrument identified by instrumentIndex
   * @param self The configuration object
   * @param instrumentIndex The index of the instrument in the bitmap
   * @param usingAsCollateral True if the user is using the instrument as collateral, false otherwise
   **/
  function setUsingAsCollateral(DataTypes.UserConfigurationMap storage self, uint256 instrumentIndex, bool usingAsCollateral) internal {
    require(instrumentIndex < 128,"Invalid instrument Index");
    self.data = (self.data & ~(1 << (instrumentIndex * 2 + 1))) | (uint256(usingAsCollateral ? 1 : 0) << (instrumentIndex * 2 + 1));
  }

  /**
   * @dev Used to validate if a user has been using the instrument for borrowing or as collateral
   * @param self The configuration object
   * @param instrumentIndex The index of the instrument in the bitmap
   * @return True if the user has been using a instrument for borrowing or as collateral, false otherwise
   **/
  function isUsingAsCollateralOrBorrowing(DataTypes.UserConfigurationMap memory self, uint256 instrumentIndex) internal pure returns (bool) {
    require(instrumentIndex < 128,"Invalid instrument Index");
    return (self.data >> (instrumentIndex * 2)) & 3 != 0;
  }

  /**
   * @dev Used to validate if a user has been using the instrument for borrowing
   * @param self The configuration object
   * @param instrumentIndex The index of the instrument in the bitmap
   * @return True if the user has been using a instrument for borrowing, false otherwise
   **/
  function isBorrowing(DataTypes.UserConfigurationMap memory self, uint256 instrumentIndex) internal pure returns (bool) {
    require(instrumentIndex < 128,"Invalid instrument Index");
    return (self.data >> (instrumentIndex * 2)) & 1 != 0;
  }

  /**
   * @dev Used to validate if a user has been using the instrument as collateral
   * @param self The configuration object
   * @param instrumentIndex The index of the instrument in the bitmap
   * @return True if the user has been using a instrument as collateral, false otherwise
   **/
  function isUsingAsCollateral(DataTypes.UserConfigurationMap memory self, uint256 instrumentIndex) internal pure returns (bool) {
    require(instrumentIndex < 128,"Invalid instrument Index");
    return (self.data >> (instrumentIndex * 2 + 1)) & 1 != 0;
  }

  /**
   * @dev Used to validate if a user has been borrowing from any instrument
   * @param self The configuration object
   * @return True if the user has been borrowing any instrument, false otherwise
   **/
  function isBorrowingAny(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
    return self.data & BORROWING_MASK != 0;
  }

  /**
   * @dev Used to validate if a user has not been using any instrument
   * @param self The configuration object
   * @return True if the user has been borrowing any instrument, false otherwise
   **/
  function isEmpty(DataTypes.UserConfigurationMap memory self) internal pure returns (bool) {
    return self.data == 0;
  }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/configuration/InstrumentConfiguration.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

  /**
  * @title InstrumentConfiguration library
  * @author Aave
  * @notice Implements the bitmap logic to handle the instrument configuration
  */
  library InstrumentConfiguration {

      uint256 constant LTV_MASK =                   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000; // prettier-ignore
      uint256 constant LIQUIDATION_THRESHOLD_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFF; // prettier-ignore
      uint256 constant LIQUIDATION_BONUS_MASK =     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFF; // prettier-ignore
      uint256 constant DECIMALS_MASK =              0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFF; // prettier-ignore
      uint256 constant ACTIVE_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant FROZEN_MASK =                0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant BORROWING_MASK =             0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant STABLE_BORROWING_MASK =      0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFFFFFFFFF; // prettier-ignore
      uint256 constant RESERVE_FACTOR_MASK =        0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FFFFFFFFFFFFFFFF; // prettier-ignore

      /// @dev For the LTV, the start bit is 0 (up to 15), hence no bitshifting is needed
      uint256 constant LIQUIDATION_THRESHOLD_START_BIT_POSITION = 16;
      uint256 constant LIQUIDATION_BONUS_START_BIT_POSITION = 32;
      uint256 constant INSTRUMENT_DECIMALS_START_BIT_POSITION = 48;
      uint256 constant IS_ACTIVE_START_BIT_POSITION = 56;
      uint256 constant IS_FROZEN_START_BIT_POSITION = 57;
      uint256 constant BORROWING_ENABLED_START_BIT_POSITION = 58;
      uint256 constant STABLE_BORROWING_ENABLED_START_BIT_POSITION = 59;
      uint256 constant RESERVE_FACTOR_START_BIT_POSITION = 64;

      uint256 constant MAX_VALID_LTV = 65535;
      uint256 constant MAX_VALID_LIQUIDATION_THRESHOLD = 65535;
      uint256 constant MAX_VALID_LIQUIDATION_BONUS = 65535;
      uint256 constant MAX_VALID_DECIMALS = 255;
      uint256 constant MAX_VALID_RESERVE_FACTOR = 65535;

    /**
    * @dev Sets the Loan to Value of the instrument
    * @param self The instrument configuration
    * @param ltv the new ltv
    **/
    function setLtv(DataTypes.InstrumentConfigurationMap memory self, uint256 ltv) internal pure {
      require(ltv <= MAX_VALID_LTV, "LTV value needs to be less than 65535");

      self.data = (self.data & LTV_MASK) | ltv;
    }

    /**
    * @dev Gets the Loan to Value of the instrument
    * @param self The instrument configuration
    * @return The loan to value
    **/
    function getLtv(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return self.data & ~LTV_MASK;
    }

    /**
    * @dev Sets the liquidation threshold of the instrument
    * @param self The instrument configuration
    * @param threshold The new liquidation threshold
    **/
    function setLiquidationThreshold(DataTypes.InstrumentConfigurationMap memory self, uint256 threshold) internal pure {
      require(threshold <= MAX_VALID_LIQUIDATION_THRESHOLD, "Liquidation Threshold value needs to be less than 65535");
      self.data = (self.data & LIQUIDATION_THRESHOLD_MASK) | (threshold << LIQUIDATION_THRESHOLD_START_BIT_POSITION);
    }

    /**
    * @dev Gets the liquidation threshold of the instrument
    * @param self The instrument configuration
    * @return The liquidation threshold
    **/
    function getLiquidationThreshold(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
    }

    /**
    * @dev Sets the liquidation bonus of the instrument
    * @param self The instrument configuration
    * @param bonus The new liquidation bonus
    **/
    function setLiquidationBonus(DataTypes.InstrumentConfigurationMap memory self, uint256 bonus) internal pure {
      require(bonus <= MAX_VALID_LIQUIDATION_BONUS, "Liquidation Bonus value needs to be less than 65535");
      self.data = (self.data & LIQUIDATION_BONUS_MASK) | (bonus << LIQUIDATION_BONUS_START_BIT_POSITION);
    }

    /**
    * @dev Gets the liquidation bonus of the instrument
    * @param self The instrument configuration
    * @return The liquidation bonus
    **/
    function getLiquidationBonus(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
    }

    /**
    * @dev Sets the decimals of the underlying asset of the instrument
    * @param self The instrument configuration
    * @param decimals The decimals
    **/
    function setDecimals(DataTypes.InstrumentConfigurationMap memory self, uint256 decimals) internal pure {
      require(decimals <= MAX_VALID_DECIMALS, "Decimals value needs to be less than 255");
      self.data = (self.data & DECIMALS_MASK) | (decimals << INSTRUMENT_DECIMALS_START_BIT_POSITION);
    }

    /**
    * @dev Gets the decimals of the underlying asset of the instrument
    * @param self The instrument configuration
    * @return The decimals of the asset
    **/
    function getDecimals(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~DECIMALS_MASK) >> INSTRUMENT_DECIMALS_START_BIT_POSITION;
    }

    /**
    * @dev Sets the active state of the instrument
    * @param self The instrument configuration
    * @param active The active state
    **/
    function setActive(DataTypes.InstrumentConfigurationMap memory self, bool active) internal pure {
      self.data = (self.data & ACTIVE_MASK) | (uint256(active ? 1 : 0) << IS_ACTIVE_START_BIT_POSITION);
    }

    /**
    * @dev Gets the active state of the instrument
    * @param self The instrument configuration
    * @return The active state
    **/
    function getActive(DataTypes.InstrumentConfigurationMap storage self) internal view returns (bool) {
      return (self.data & ~ACTIVE_MASK) != 0;
    }

    /**
    * @dev Sets the frozen state of the instrument
    * @param self The instrument configuration
    * @param frozen The frozen state
    **/
    function setFrozen(DataTypes.InstrumentConfigurationMap memory self, bool frozen) internal pure {
      self.data = (self.data & FROZEN_MASK) | (uint256(frozen ? 1 : 0) << IS_FROZEN_START_BIT_POSITION);
    }

    /**
    * @dev Gets the frozen state of the instrument
    * @param self The instrument configuration
    * @return The frozen state
    **/
    function getFrozen(DataTypes.InstrumentConfigurationMap storage self) internal view returns (bool) {
      return (self.data & ~FROZEN_MASK) != 0;
    }

    /**
    * @dev Enables or disables borrowing on the instrument
    * @param self The instrument configuration
    * @param enabled True if the borrowing needs to be enabled, false otherwise
    **/
    function setBorrowingEnabled(DataTypes.InstrumentConfigurationMap memory self, bool enabled) internal pure {
      self.data = (self.data & BORROWING_MASK) | (uint256(enabled ? 1 : 0) << BORROWING_ENABLED_START_BIT_POSITION);
    }

    /**
    * @dev Gets the borrowing state of the instrument
    * @param self The instrument configuration
    * @return The borrowing state
    **/
    function getBorrowingEnabled(DataTypes.InstrumentConfigurationMap storage self) internal view returns (bool) {
      return (self.data & ~BORROWING_MASK) != 0;
    }

    /**
    * @dev Enables or disables stable rate borrowing on the instrument
    * @param self The instrument configuration
    * @param enabled True if the stable rate borrowing needs to be enabled, false otherwise
    **/
    function setStableRateBorrowingEnabled(DataTypes.InstrumentConfigurationMap memory self, bool enabled) internal  pure {
      self.data =  (self.data & STABLE_BORROWING_MASK) |  (uint256(enabled ? 1 : 0) << STABLE_BORROWING_ENABLED_START_BIT_POSITION);
    }

    /**
    * @dev Gets the stable rate borrowing state of the instrument
    * @param self The instrument configuration
    * @return The stable rate borrowing state
    **/
    function getStableRateBorrowingEnabled(DataTypes.InstrumentConfigurationMap storage self)  internal  view  returns (bool) {
      return (self.data & ~STABLE_BORROWING_MASK) != 0;
    }

    /**
    * @dev Sets the reserve factor of the instrument
    * @param self The instrument configuration
    * @param reserveFactor The reserve factor
    **/
    function setReserveFactor(DataTypes.InstrumentConfigurationMap memory self, uint256 reserveFactor) internal pure {
      require(reserveFactor <= MAX_VALID_RESERVE_FACTOR, "Reserve Factor value not valid. It needs to be less than 65535");
      self.data = (self.data & RESERVE_FACTOR_MASK) | (reserveFactor << RESERVE_FACTOR_START_BIT_POSITION);
    }

    /**
    * @dev Gets the reserve factor of the instrument
    * @param self The instrument configuration
    * @return The reserve factor
    **/
    function getReserveFactor(DataTypes.InstrumentConfigurationMap storage self) internal view returns (uint256) {
      return (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
    }

    /**
    * @dev Gets the configuration flags of the instrument
    * @param self The instrument configuration
    **/
    function getFlags(DataTypes.InstrumentConfigurationMap storage self)  internal  view  returns (bool isActive,bool isFrozen,bool isBorrowingEnabled ,bool isStableBorrowingEnabled) {
        uint256 dataLocal = self.data;
        isActive = (dataLocal & ~ACTIVE_MASK) != 0;
        isFrozen = (dataLocal & ~FROZEN_MASK) != 0;
        isBorrowingEnabled = (dataLocal & ~BORROWING_MASK) != 0;
        isStableBorrowingEnabled = (dataLocal & ~STABLE_BORROWING_MASK) != 0;
    }

    /**
    * @dev Gets the configuration parameters of the instrument reserve
    * @param self The instrument configuration
    **/
    function getParams(DataTypes.InstrumentConfigurationMap storage self)  internal view  returns ( uint256 ltv,uint256 liquidation_threshold, uint256 liquidation_bonus , uint256 decimals, uint256 reserveFactor) {
      uint256 dataLocal = self.data;
      ltv = dataLocal & ~LTV_MASK;
      liquidation_threshold = (dataLocal & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
      liquidation_bonus = (dataLocal & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
      decimals = (dataLocal & ~DECIMALS_MASK) >> INSTRUMENT_DECIMALS_START_BIT_POSITION;
      reserveFactor = (dataLocal & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
    }

    /**
    * @dev Gets the configuration paramters of the instrument from a memory object
    * @param self The instrument configuration
    **/
    function getParamsMemory(DataTypes.InstrumentConfigurationMap memory self)  internal pure returns ( uint256 ltv,uint256 liquidation_threshold, uint256 liquidation_bonus , uint256 decimals, uint256 reserveFactor) {
      ltv = self.data & ~LTV_MASK;
      liquidation_threshold = (self.data & ~LIQUIDATION_THRESHOLD_MASK) >> LIQUIDATION_THRESHOLD_START_BIT_POSITION;
      liquidation_bonus = (self.data & ~LIQUIDATION_BONUS_MASK) >> LIQUIDATION_BONUS_START_BIT_POSITION;
      decimals = (self.data & ~DECIMALS_MASK) >> INSTRUMENT_DECIMALS_START_BIT_POSITION;
      reserveFactor = (self.data & ~RESERVE_FACTOR_MASK) >> RESERVE_FACTOR_START_BIT_POSITION;
    }

    /**
    * @dev Gets the configuration flags of the instrument from a memory object
    * @param self The instrument configuration
    **/
    function getFlagsMemory(DataTypes.InstrumentConfigurationMap memory self) internal pure returns (bool isActive,bool isFrozen,bool isBorrowingEnabled ,bool isStableBorrowingEnabled) {
        isActive = (self.data & ~ACTIVE_MASK) != 0;
        isFrozen = (self.data & ~FROZEN_MASK) != 0;
        isBorrowingEnabled = (self.data & ~BORROWING_MASK) != 0;
        isStableBorrowingEnabled = (self.data & ~STABLE_BORROWING_MASK) != 0;
    }

  }

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/IERC20.sol

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/utils/Address.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
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

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
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
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
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
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/openzeppelin/token/ERC20/SafeERC20.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
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

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
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
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/WadRayMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title WadRayMath library
 * @author Aave
 * @dev Provides mul and div function for wads (decimal numbers with 18 digits precision) and rays (decimals with 27 digits)
 **/

library WadRayMath {
  uint256 internal constant WAD = 1e18;
  uint256 internal constant halfWAD = WAD / 2;

  uint256 internal constant RAY = 1e27;
  uint256 internal constant halfRAY = RAY / 2;

  uint256 internal constant WAD_RAY_RATIO = 1e9;

  /**
   * @return One ray, 1e27
   **/
  function ray() internal pure returns (uint256) {
    return RAY;
  }

  /**
   * @return One wad, 1e18
   **/

  function wad() internal pure returns (uint256) {
    return WAD;
  }

  /**
   * @return Half ray, 1e27/2
   **/
  function halfRay() internal pure returns (uint256) {
    return halfRAY;
  }

  /**
   * @return Half ray, 1e18/2
   **/
  function halfWad() internal pure returns (uint256) {
    return halfWAD;
  }

  /**
   * @dev Multiplies two wad, rounding half up to the nearest wad
   * @param a Wad
   * @param b Wad
   * @return The result of a*b, in wad
   **/
  function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0 || b == 0) {
      return 0;
    }

    require(a <= (type(uint256).max - halfWAD) / b, "MATH_MULTIPLICATION_OVERFLOW");

    return (a * b + halfWAD) / WAD;
  }

  /**
   * @dev Divides two wad, rounding half up to the nearest wad
   * @param a Wad
   * @param b Wad
   * @return The result of a/b, in wad
   **/
  function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, "MATH_DIVISION_BY_ZERO");
    uint256 halfB = b / 2;

    require(a <= (type(uint256).max - halfB) / WAD, "MATH_MULTIPLICATION_OVERFLOW");

    return (a * WAD + halfB) / b;
  }

  /**
   * @dev Multiplies two ray, rounding half up to the nearest ray
   * @param a Ray
   * @param b Ray
   * @return The result of a*b, in ray
   **/
  function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0 || b == 0) {
      return 0;
    }

    require(a <= (type(uint256).max - halfRAY) / b, "MATH_MULTIPLICATION_OVERFLOW");

    return (a * b + halfRAY) / RAY;
  }

  /**
   * @dev Divides two ray, rounding half up to the nearest ray
   * @param a Ray
   * @param b Ray
   * @return The result of a/b, in ray
   **/
  function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, "MATH_DIVISION_BY_ZERO");
    uint256 halfB = b / 2;

    require(a <= (type(uint256).max - halfB) / RAY, "MATH_MULTIPLICATION_OVERFLOW");

    return (a * RAY + halfB) / b;
  }

  /**
   * @dev Casts ray down to wad
   * @param a Ray
   * @return a casted to wad, rounded half up to the nearest wad
   **/
  function rayToWad(uint256 a) internal pure returns (uint256) {
    uint256 halfRatio = WAD_RAY_RATIO / 2;
    uint256 result = halfRatio + a;
    require(result >= halfRatio, "MATH_ADDITION_OVERFLOW");

    return result / WAD_RAY_RATIO;
  }

  /**
   * @dev Converts wad up to ray
   * @param a Wad
   * @return a converted in ray
   **/
  function wadToRay(uint256 a) internal pure returns (uint256) {
    uint256 result = a * WAD_RAY_RATIO;
    require(result / WAD_RAY_RATIO == a, "MATH MULTIPLICATION OVERFLOW");
    return result;
  }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/MathUtils.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;


library MathUtils {
    using SafeMath for uint256;
    using WadRayMath for uint256;

    /// @dev Ignoring leap years
    uint256 internal constant SECONDS_PER_YEAR = 365 days;

    /**
    * @dev Function to calculate the interest accumulated using a linear interest rate formula
    * @param rate The interest rate, in ray
    * @param lastUpdateTimestamp The timestamp of the last update of the interest
    * @return The interest rate linearly accumulated during the timeDelta, in ray
    **/
    function calculateLinearInterest(uint256 rate, uint40 lastUpdateTimestamp) internal view returns (uint256) {
        uint256 timeDifference = block.timestamp.sub(uint256(lastUpdateTimestamp));
        return (rate.mul(timeDifference) / SECONDS_PER_YEAR).add(WadRayMath.ray());
    }

    /**
    * @dev Function to calculate the interest using a compounded interest rate formula
    * To avoid expensive exponentiation, the calculation is performed using a binomial approximation:
    *
    *  (1+x)^n = 1+n*x+[n/2*(n-1)]*x^2+[n/6*(n-1)*(n-2)*x^3...
    *
    * The approximation slightly underpays liquidity providers and undercharges borrowers, with the advantage of great gas cost reductions
    * The whitepaper contains reference to the approximation and a table showing the margin of error per different time periods
    *
    * @param rate The interest rate, in ray
    * @param lastUpdateTimestamp The timestamp of the last update of the interest
    * @return The interest rate compounded during the timeDelta, in ray
    **/
    function calculateCompoundedInterest( uint256 rate, uint40 lastUpdateTimestamp, uint256 currentTimestamp) internal pure returns (uint256) {
        uint256 exp = currentTimestamp.sub(uint256(lastUpdateTimestamp));

        if (exp == 0) {
            return WadRayMath.ray();
        }

        uint256 expMinusOne = exp - 1;
        uint256 expMinusTwo = exp > 2 ? exp - 2 : 0;

        uint256 ratePerSecond = rate / SECONDS_PER_YEAR;

        uint256 basePowerTwo = ratePerSecond.rayMul(ratePerSecond);
        uint256 basePowerThree = basePowerTwo.rayMul(ratePerSecond);

        uint256 secondTerm = exp.mul(expMinusOne).mul(basePowerTwo) / 2;
        uint256 thirdTerm = exp.mul(expMinusOne).mul(expMinusTwo).mul(basePowerThree) / 6;

        return WadRayMath.ray().add(ratePerSecond.mul(exp)).add(secondTerm).add(thirdTerm);
    }

    /**
    * @dev Calculates the compounded interest between the timestamp of the last update and the current block timestamp
    * @param rate The interest rate (in ray)
    * @param lastUpdateTimestamp The timestamp from which the interest accumulation needs to be calculated
    **/
    function calculateCompoundedInterest(uint256 rate, uint40 lastUpdateTimestamp) internal view returns (uint256) {
        return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/math/PercentageMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title PercentageMath library
 * @author Aave
 * @notice Provides functions to perform percentage calculations
 * @dev Percentages are defined by default with 2 decimals of precision (100.00). The precision is indicated by PERCENTAGE_FACTOR
 * @dev Operations are rounded half up
 **/

library PercentageMath {
    uint256 constant PERCENTAGE_FACTOR = 1e4; //percentage plus two decimals
    uint256 constant HALF_PERCENT = PERCENTAGE_FACTOR / 2;

    /**
    * @dev Executes a percentage multiplication
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return The percentage of value
    **/
    function percentMul(uint256 value, uint256 percentage) internal pure returns (uint256) {
        if (value == 0 || percentage == 0) {
            return 0;
        }

        require(value <= (type(uint256).max - HALF_PERCENT) / percentage, "Percentage Math : Multiplication error" );
        return (value * percentage + HALF_PERCENT) / PERCENTAGE_FACTOR;
    }

    /**
    * @dev Executes a percentage division
    * @param value The value of which the percentage needs to be calculated
    * @param percentage The percentage of the value to be calculated
    * @return The value divided the percentage
    **/
    function percentDiv(uint256 value, uint256 percentage) internal pure returns (uint256) {
        require(percentage != 0, "MATH DIVISION BY ZERO");
        uint256 halfPercentage = percentage / 2;

        require( value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR, "Percentage Math : Division error" );
        return (value * PERCENTAGE_FACTOR + halfPercentage) / percentage;
    }
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IInstrumentInterestRateStrategy.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title IReserveInterestRateStrategyInterface interface
 * @dev Interface for the calculation of the interest rates
 * @author Aave
 */
interface IInstrumentInterestRateStrategy {

  function baseVariableBorrowRate() external view returns (uint256);
  function getMaxVariableBorrowRate() external view returns (uint256);

  function calculateInterestRates(address reserve, uint256 utilizationRate, uint256 totalStableDebt, uint256 totalVariableDebt, uint256 averageStableBorrowRate, uint256 reserveFactor) external view returns (uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IScaledBalanceToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface IScaledBalanceToken {
  /**
   * @dev Returns the scaled balance of the user. The scaled balance is the sum of all the
   * updated stored balance divided by the reserve's liquidity index at the moment of the update
   * @param user The user whose balance is calculated
   * @return The scaled balance of the user
   **/
  function scaledBalanceOf(address user) external view returns (uint256);

  /**
   * @dev Returns the scaled balance of the user and the scaled total supply.
   * @param user The address of the user
   * @return The scaled balance of the user
   * @return The scaled balance and the scaled total supply
   **/
  function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);

  /**
   * @dev Returns the scaled total supply of the variable debt token. Represents sum(debt/index)
   * @return The scaled total supply
   **/
  function scaledTotalSupply() external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IVariableDebtToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title IVariableDebtToken
 * @author Aave
 * @notice Defines the basic interface for a variable debt token.
 **/
interface IVariableDebtToken is IScaledBalanceToken {

//  ##############################################
//  ##################  EVENTS ###################
//  ##############################################

  /**
   * @dev Emitted after the mint action
   * @param from The address performing the mint
   * @param onBehalfOf The address of the user on which behalf minting has been performed
   * @param value The amount to be minted
   * @param index The last index of the reserve
   **/
  event Mint(address indexed from, address indexed onBehalfOf, uint256 value, uint256 index);

  /**
   * @dev Emitted when variable debt is burnt
   * @param user The user which debt has been burned
   * @param amount The amount of debt being burned
   * @param index The index of the user
   **/
  event Burn(address indexed user, uint256 amount, uint256 index);

//  ################################################
//  ################## FUNCTIONS ###################
//  ################################################

  /**
   * @dev Mints debt token to the `onBehalfOf` address
   * @param user The address receiving the borrowed underlying, being the delegatee in case
   * of credit delegate, or same as `onBehalfOf` otherwise
   * @param onBehalfOf The address receiving the debt tokens
   * @param amount The amount of debt being minted
   * @param index The variable debt index of the reserve
   * @return `true` if the the previous balance of the user is 0
   **/
  function mint(address user, address onBehalfOf, uint256 amount, uint256 index) external returns (bool);



  /**
   * @dev Burns user variable debt
   * @param user The user which debt is burnt
   * @param index The variable debt index of the reserve
   **/
  function burn(address user, uint256 amount, uint256 index) external;

  function averageBalanceOf(address account) external view returns (uint256);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IStableDebtToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title IStableDebtToken
 * @notice Defines the interface for the stable debt token
 * @dev It does not inherit from IERC20 to save in code size
 * @author Aave, _astromartian
 **/

interface IStableDebtToken {

//  ##############################################
//  ##################  EVENTS ###################
//  ##############################################

  /**
   * @dev Emitted when new stable debt is minted
   * @param user The address of the user who triggered the minting
   * @param onBehalfOf The recipient of stable debt tokens
   * @param amount The amount minted
   * @param currentBalance The current balance of the user
   * @param balanceIncrease The increase in balance since the last action of the user
   * @param newRate The rate of the debt after the minting
   * @param avgStableRate The new average stable rate after the minting
   * @param newTotalSupply The new total supply of the stable debt token after the action
   **/
  event Mint(address indexed user, address indexed onBehalfOf, uint256 amount, uint256 currentBalance, uint256 balanceIncrease, uint256 newRate, uint256 avgStableRate, uint256 newTotalSupply);

  /**
   * @dev Emitted when new stable debt is burned
   * @param user The address of the user
   * @param amount The amount being burned
   * @param currentBalance The current balance of the user
   * @param balanceIncrease The the increase in balance since the last action of the user
   * @param avgStableRate The new average stable rate after the burning
   * @param newTotalSupply The new total supply of the stable debt token after the action
   **/
  event Burn(address indexed user, uint256 amount, uint256 currentBalance, uint256 balanceIncrease, uint256 avgStableRate, uint256 newTotalSupply);

//  ################################################
//  ################## FUNCTIONS ###################
//  ################################################

  /**
   * @dev Mints debt token to the `onBehalfOf` address.
   * - The resulting rate is the weighted average between the rate of the new debt
   * and the rate of the previous debt
   * @param user The address receiving the borrowed underlying, being the delegatee in case
   * of credit delegate, or same as `onBehalfOf` otherwise
   * @param onBehalfOf The address receiving the debt tokens
   * @param amount The amount of debt tokens to mint
   * @param rate The rate of the debt being minted
   **/
  function mint(address user, address onBehalfOf, uint256 amount, uint256 rate) external returns (bool);

  /**
   * @dev Burns debt of `user`
   * - The resulting rate is the weighted average between the rate of the new debt
   * and the rate of the previous debt
   * @param user The address of the user getting his debt burned
   * @param amount The amount of debt tokens getting burned
   **/
  function burn(address user, uint256 amount) external;

  /**
   * @dev Returns the average rate of all the stable rate loans.
   * @return The average stable rate
   **/
  function getAverageStableRate() external view returns (uint256);

  /**
   * @dev Returns the stable rate of the user debt
   * @return The stable rate of the user
   **/
  function getUserStableRate(address user) external view returns (uint256);

  /**
   * @dev Returns the timestamp of the last update of the user
   * @return The timestamp
   **/
  function getUserLastUpdated(address user) external view returns (uint40);

  /**
   * @dev Returns the principal, the total supply and the average stable rate
   **/
  function getSupplyData() external view returns (uint256, uint256, uint256, uint40);

  /**
   * @dev Returns the timestamp of the last update of the total supply
   * @return The timestamp
   **/
  function getTotalSupplyLastUpdated() external view returns (uint40);

  /**
   * @dev Returns the total supply and the average stable rate
   **/
  function getTotalSupplyAndAvgRate() external view returns (uint256, uint256);

  /**
   * @dev Returns the principal debt balance of the user
   * @return The debt balance of the user since the last burn/mint action
   **/
  function principalBalanceOf(address user) external view returns (uint256);

  function averageBalanceOf(address account) external view returns (uint256);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IIToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;


interface IIToken is IERC20, IScaledBalanceToken {

//  ##############################################
//  ##################  EVENTS ###################
//  ##############################################

  /**
   * @dev Emitted after the mint action
   * @param from The address performing the mint
   * @param value The amount
   * @param index The new liquidity index of the instrument
   **/
  event Mint(address indexed from, uint256 value, uint256 index);


  /**
   * @dev Emitted after iTokens are burned
   * @param from The owner of the iTokens, getting them burned
   * @param target The address that will receive the underlying
   * @param value The amount being burned
   * @param index The new liquidity index of the reserve
   **/
  event Burn(address indexed from, address indexed target, uint256 value, uint256 index);

  /**
   * @dev Emitted during the transfer action
   * @param from The user whose tokens are being transferred
   * @param to The recipient
   * @param value The amount being transferred
   * @param index The new liquidity index of the reserve
   **/
  event BalanceTransfer(address indexed from, address indexed to, uint256 value, uint256 index);

//  ################################################
//  ################## FUNCTIONS ###################
//  ################################################

  /**
   * @dev Mints `amount` iTokens to `user`
   * @param user The address receiving the minted tokens
   * @param amount The amount of tokens getting minted
   * @param index The new liquidity index of the reserve
   * @return `true` if the the previous balance of the user was 0
   */
  function mint(address user, uint256 amount, uint256 index) external returns (bool);

  /**
   * @dev Burns iTokens from `user` and sends the equivalent amount of underlying to `receiverOfUnderlying`
   * @param user The owner of the iTokens, getting them burned
   * @param receiverOfUnderlying The address that will receive the underlying
   * @param amount The amount being burned
   * @param index The new liquidity index of the reserve
   **/
  function burn(address user, address receiverOfUnderlying, uint256 amount, uint256 index) external;

  /**
   * @dev Mints iTokens to the reserve treasury
   * @param amount The amount of tokens getting minted
   * @param sighPayAggregator Reserve Collector Address which received the iTokens
   * @param index The new liquidity index of the reserve
   */
  function mintToTreasury(uint256 amount, address sighPayAggregator, uint256 index) external;

  /**
   * @dev Transfers iTokens in the event of a borrow being liquidated, in case the liquidators reclaims the iToken
   * @param from The address getting liquidated, current owner of the iTokens
   * @param to The recipient
   * @param value The amount of tokens getting transferred
   **/
  function transferOnLiquidation(address from, address to, uint256 value) external;

  /**
   * @dev Transfers the underlying asset to `target`. Used by the LendingPool to transfer assets in borrow(), withdraw() and flashLoan()
   * @param user The recipient of the iTokens
   * @param amount The amount getting transferred
   * @return The amount transferred
   **/
  function transferUnderlyingTo(address user, uint256 amount) external returns (uint256);

  function claimSIGH(address[] calldata users) external;
  function claimMySIGH() external;
  function getSighAccured(address user)  external view returns (uint);

  function setSIGHHarvesterAddress(address _SIGHHarvesterAddress) external returns (bool);

  function averageBalanceOf(address account) external view returns (uint256);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/IFeeProviderLendingPool.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
* @title FeeProvider contract Interface
* @notice Implements calculation for the fees applied by the protocol based on the Boosters
* @author SIGH Finance (_astromartian)
**/
interface IFeeProviderLendingPool  {

    function calculateDepositFee(address _user,address instrument, uint256 _amount, uint boosterId) external returns (uint256 ,uint256 ,uint256 );
    function calculateBorrowFee(address _user, address instrument, uint256 _amount, uint boosterId) external returns (uint256 platformFee, uint256 reserveFee) ;
    function calculateFlashLoanFee(address _user, uint256 _amount, uint boosterId) external view returns (uint256 ,uint256 ,uint256) ;
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/lendingProtocol/ISIGHHarvestDebtToken.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface ISIGHHarvestDebtToken {

  function setSIGHHarvesterAddress(address _SIGHHarvesterAddress) external  returns (bool) ;

  function claimSIGH(address[] memory users) external  ;
  function claimMySIGH() external ;

  function getSighAccured(address user)  external view  returns (uint) ;

//  ############################################
//  ######### FUNCTIONS RELATED TO FEE #########
//  ############################################

  function updatePlatformFee(address user, uint platformFeeIncrease, uint platformFeeDecrease) external  ;
  function updateReserveFee(address user, uint reserveFeeIncrease, uint reserveFeeDecrease) external  ;

  function getPlatformFee(address user) external view returns (uint) ;
  function getReserveFee(address user)  external view returns (uint) ;

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/helpers/Errors.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Errors library
 * @author Aave
 * @notice Defines the error messages emitted by the different contracts of the Aave protocol
 * @dev Error messages prefix glossary:
 *  - VL = ValidationLogic
 *  - MATH = Math libraries
 *  - CT = Common errors between tokens (AToken, VariableDebtToken and StableDebtToken)
 *  - AT = AToken
 *  - SDT = StableDebtToken
 *  - VDT = VariableDebtToken
 *  - LP = LendingPool
 *  - LPAPR = LendingPoolAddressesProviderRegistry
 *  - LPC = LendingPoolConfiguration
 *  - RL = ReserveLogic
 *  - LPCM = LendingPoolCollateralManager
 *  - P = Pausable
 */
library Errors {
  //common errors

  string public constant MAX_INST_LIMIT = '1';
  string public constant PAUSED = '2';
  string public constant FAILED = '3';
  string public constant INVALID_RETURN = '4';
  string public constant NOT_ALLOWED = '5';
  string public constant NOT_CONTRACT = '6';
  string public constant VOL_HAR_INIT_FAIL = '7';
  string public constant IT_INIT_FAIL = '8';
  string public constant VT_INIT_FAIL = '9';
  string public constant ST_INIT_FAIL = '10';

  string public constant Already_Supported = '11';
  string public constant LR_INVALID = '12';
  string public constant SR_INVALID = '13';
  string public constant VR_INVALID = '14';

  string public constant CLI_OVRFLW = '15';
  string public constant LI_OVRFLW = '16';
  string public constant VI_OVRFLW = '17';  
  string public constant LIQUIDITY_NOT_AVAILABLE = '18'; 
  string public constant INCONCISTENT_BALANCE = '20'; 



  string public constant CALLER_NOT_POOL_ADMIN = '33'; // 'The caller must be the pool admin'
  string public constant BORROW_ALLOWANCE_NOT_ENOUGH = '59'; // User borrows on behalf, but allowance are too small

  //contract specific errors
  string public constant LPCM_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; // 'Health factor is not below the threshold'
  string public constant LPCM_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; // 'The collateral chosen cannot be liquidated'
  string public constant LPCM_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; // 'User did not borrow the specified currency'
  string public constant LPCM_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; // "There isn't enough liquidity available to liquidate"
  string public constant LPCM_NO_ERRORS = '46'; // 'No errors'

  enum CollateralManagerErrors {
    NO_ERROR,
    NO_COLLATERAL_AVAILABLE,
    COLLATERAL_CANNOT_BE_LIQUIDATED,
    CURRRENCY_NOT_BORROWED,
    HEALTH_FACTOR_ABOVE_THRESHOLD,
    NOT_ENOUGH_LIQUIDITY,
    NO_ACTIVE_INSTRUMENT,
    HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD,
    INVALID_EQUAL_ASSETS_TO_SWAP,
    FROZEN_INSTRUMENT
  }

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/logic/InstrumentReserveLogic.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;












/**
 * @title ReserveLogic library
 * @author Aave
 * @notice Implements the logic to update the reserves state
 */
library InstrumentReserveLogic {

    using SafeMath for uint256;
    using WadRayMath for uint256;
    using PercentageMath for uint256;
    using SafeERC20 for IERC20;

    using InstrumentReserveLogic for DataTypes.InstrumentData;
    using InstrumentConfiguration for DataTypes.InstrumentConfigurationMap;


    /**
    * @dev Emitted when the state of a reserve is updated
    * @param asset The address of the underlying asset of the reserve
    * @param liquidityRate The new liquidity rate
    * @param stableBorrowRate The new stable borrow rate
    * @param variableBorrowRate The new variable borrow rate
    * @param liquidityIndex The new liquidity index
    * @param variableBorrowIndex The new variable borrow index
    **/
    event InstrumentDataUpdated(address indexed asset,uint256 liquidityRate, uint256 stableBorrowRate, uint256 variableBorrowRate,uint256 liquidityIndex, uint256 variableBorrowIndex);

  /**
   * @dev Emitted on deposit()
   * @param instrumentAddress The address of the underlying asset 
   * @param user The address initiating the deposit
   * @param amount The amount deposited
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/
  event depositFeeDeducted(address instrumentAddress, address user, uint amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);
  
  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address that will be getting the debt
   * @param amount The amount borrowed out
   * @param platformFee Platform Fee charged
   * @param reserveFee Reserve Fee charged
   * @param _boosterId The boosterID of the Booster used to get a discount on the Fee
   **/  
  event borrowFeeUpdated(address instrumentAddress, address user, uint256 amount, uint256 platformFee, uint256 reserveFee, uint16 _boosterId);

  /**
   * @dev Emitted on borrow() and flashLoan() when debt needs to be opened
   * @param instrumentAddress The address of the underlying asset being borrowed
   * @param user The address repaying the amount
   * @param onBehalfOf The user whose debt is being repaid
   * @param amount The amount borrowed out
   * @param platformFeePay Platform Fee paid
   * @param reserveFeePay Reserve Fee paid
   **/  
  event feeRepaid(address instrumentAddress, address user, address onBehalfOf, uint256 amount, uint256 platformFeePay, uint256 reserveFeePay);



    /**
    * @dev Returns the ongoing normalized income for the reserve
    * A value of 1e27 means there is no income. As time passes, the income is accrued
    * A value of 2*1e27 means for each unit of asset one unit of income has been accrued
    * @param reserve The reserve object
    * @return the normalized income. expressed in ray
    **/
    function getNormalizedIncome(DataTypes.InstrumentData storage reserve) internal view returns (uint256) {
        uint40 timestamp = reserve.lastUpdateTimestamp;

        if (timestamp == uint40(block.timestamp)) {
            return reserve.liquidityIndex;  //if the index was updated in the same block, no need to perform any calculation
        }

        uint256 cumulated = MathUtils.calculateLinearInterest(reserve.currentLiquidityRate, timestamp).rayMul( reserve.liquidityIndex );
        return cumulated;
    }

    /**
    * @dev Returns the ongoing normalized variable debt for the reserve
    * A value of 1e27 means there is no debt. As time passes, the income is accrued
    * A value of 2*1e27 means that for each unit of debt, one unit worth of interest has been accumulated
    * @param reserve The reserve object
    * @return The normalized variable debt. expressed in ray
    **/
    function getNormalizedDebt(DataTypes.InstrumentData storage reserve) internal view returns (uint256) {
        uint40 timestamp = reserve.lastUpdateTimestamp;

        if (timestamp == uint40(block.timestamp)) {
            return reserve.variableBorrowIndex;
        }

        uint256 cumulated = MathUtils.calculateCompoundedInterest(reserve.currentVariableBorrowRate, timestamp).rayMul(reserve.variableBorrowIndex);
        return cumulated;
    }

    /**
    * @dev Updates the liquidity cumulative index and the variable borrow index.
    * @param instrument the instrument object
    **/
    function updateState(DataTypes.InstrumentData storage instrument, address sighPayAggregator ) internal {
        uint256 scaledVariableDebt = IVariableDebtToken(instrument.variableDebtTokenAddress).scaledTotalSupply();
        uint256 previousVariableBorrowIndex = instrument.variableBorrowIndex;
        uint256 previousLiquidityIndex = instrument.liquidityIndex;
        uint40 lastUpdatedTimestamp = instrument.lastUpdateTimestamp;

        (uint256 newLiquidityIndex, uint256 newVariableBorrowIndex) = _updateIndexes( instrument, scaledVariableDebt, previousLiquidityIndex, previousVariableBorrowIndex, lastUpdatedTimestamp );
        _mintToTreasury( instrument, sighPayAggregator, scaledVariableDebt, previousVariableBorrowIndex, newLiquidityIndex, newVariableBorrowIndex, lastUpdatedTimestamp );
    }

    /**
    * @dev Accumulates a predefined amount of asset to the reserve of the instrument as a fixed, instantaneous income. Used for example to accumulate the flashloan fee to the reserve, and spread it between all the depositors
    * @param instrument The instrument object
    * @param totalLiquidity The total liquidity available in the reserve for the instrument
    * @param amount The amount to accomulate
    **/
    function cumulateToLiquidityIndex( DataTypes.InstrumentData storage instrument, uint256 totalLiquidity, uint256 amount ) internal {
        uint256 amountToLiquidityRatio = amount.wadToRay().rayDiv(totalLiquidity.wadToRay());
        uint256 result = amountToLiquidityRatio.add(WadRayMath.ray());

        result = result.rayMul(instrument.liquidityIndex);
        require(result <= type(uint128).max, Errors.CLI_OVRFLW);

        instrument.liquidityIndex = uint128(result);
    }

    /**
    * @dev Initializes an instrument reserve
    * @param instrument The instrument object
    * @param iTokenAddress The address of the overlying atoken contract
    * @param interestRateStrategyAddress The address of the interest rate strategy contract
    **/
    function init( DataTypes.InstrumentData storage instrument, address iTokenAddress, address stableDebtTokenAddress, address variableDebtTokenAddress, address interestRateStrategyAddress) external {
        require(instrument.iTokenAddress == address(0), Errors.Already_Supported);

        instrument.liquidityIndex = uint128(WadRayMath.ray());
        instrument.variableBorrowIndex = uint128(WadRayMath.ray());
        instrument.iTokenAddress = iTokenAddress;
        instrument.stableDebtTokenAddress = stableDebtTokenAddress;
        instrument.variableDebtTokenAddress = variableDebtTokenAddress;
        instrument.interestRateStrategyAddress = interestRateStrategyAddress;
    }

    struct UpdateInterestRatesLocalVars {
      address stableDebtTokenAddress;
      uint256 availableLiquidity;
      uint256 totalStableDebt;
      uint256 newLiquidityRate;
      uint256 newStableRate;
      uint256 newVariableRate;
      uint256 avgStableRate;
      uint256 totalVariableDebt;
    }

    /**
    * @dev Updates the instrument current stable borrow rate, the current variable borrow rate and the current liquidity rate
    * @param instrumentAddress The address of the instrument to be updated
    * @param liquidityAdded The amount of liquidity added to the protocol (deposit or repay) in the previous action
    * @param liquidityTaken The amount of liquidity taken from the protocol (redeem or borrow)
    **/
    function updateInterestRates( DataTypes.InstrumentData storage instrument, address instrumentAddress, address iTokenAddress, uint256 liquidityAdded, uint256 liquidityTaken ) internal {
        UpdateInterestRatesLocalVars memory vars;

        vars.stableDebtTokenAddress = instrument.stableDebtTokenAddress;
        (vars.totalStableDebt, vars.avgStableRate) = IStableDebtToken(vars.stableDebtTokenAddress).getTotalSupplyAndAvgRate();

        //calculates the total variable debt locally using the scaled total supply instead of totalSupply(),
        // as it's noticeably cheaper. Also, the index has been updated by the previous updateState() call
        vars.totalVariableDebt = IVariableDebtToken(instrument.variableDebtTokenAddress).scaledTotalSupply().rayMul(instrument.variableBorrowIndex);
        vars.availableLiquidity = IERC20(instrumentAddress).balanceOf(iTokenAddress);

        (vars.newLiquidityRate, vars.newStableRate, vars.newVariableRate) = IInstrumentInterestRateStrategy(instrument.interestRateStrategyAddress).calculateInterestRates(
                                                                                                                                                instrumentAddress,
                                                                                                                                                vars.availableLiquidity.add(liquidityAdded).sub(liquidityTaken),
                                                                                                                                                vars.totalStableDebt,
                                                                                                                                                vars.totalVariableDebt,
                                                                                                                                                vars.avgStableRate,
                                                                                                                                                instrument.configuration.getReserveFactor()
                                                                                                                                            );
        require(vars.newLiquidityRate <= type(uint128).max, Errors.LR_INVALID);
        require(vars.newStableRate <= type(uint128).max, Errors.SR_INVALID);
        require(vars.newVariableRate <= type(uint128).max, Errors.VR_INVALID);

        instrument.currentLiquidityRate = uint128(vars.newLiquidityRate);
        instrument.currentStableBorrowRate = uint128(vars.newStableRate);
        instrument.currentVariableBorrowRate = uint128(vars.newVariableRate);

        emit InstrumentDataUpdated( instrumentAddress, vars.newLiquidityRate, vars.newStableRate,  vars.newVariableRate,  instrument.liquidityIndex,  instrument.variableBorrowIndex );
    }


    struct MintToTreasuryLocalVars {
      uint256 currentStableDebt;
      uint256 principalStableDebt;
      uint256 previousStableDebt;
      uint256 currentVariableDebt;
      uint256 previousVariableDebt;
      uint256 avgStableRate;
      uint256 cumulatedStableInterest;
      uint256 totalDebtAccrued;
      uint256 amountToMint;
      uint256 reserveFactor;
      uint40 stableSupplyUpdatedTimestamp;
    }

    /**
    * @dev Mints part of the repaid interest to the Reserve Treasury as a function of the reserveFactor for the specific asset.
    * @param instrument The instrument reserve to be updated
    * @param scaledVariableDebt The current scaled total variable debt
    * @param previousVariableBorrowIndex The variable borrow index before the last accumulation of the interest
    * @param newLiquidityIndex The new liquidity index
    * @param newVariableBorrowIndex The variable borrow index after the last accumulation of the interest
    **/
    function _mintToTreasury( DataTypes.InstrumentData storage instrument, address sighPayAggregator, uint256 scaledVariableDebt, uint256 previousVariableBorrowIndex, uint256 newLiquidityIndex, uint256 newVariableBorrowIndex, uint40 timestamp ) internal {
        MintToTreasuryLocalVars memory vars;
        vars.reserveFactor = instrument.configuration.getReserveFactor();

        if (vars.reserveFactor == 0) {
            return;
        }

        //fetching the principal, total stable debt and the avg stable rate
        ( vars.principalStableDebt, vars.currentStableDebt, vars.avgStableRate, vars.stableSupplyUpdatedTimestamp) = IStableDebtToken(instrument.stableDebtTokenAddress).getSupplyData();

        vars.previousVariableDebt = scaledVariableDebt.rayMul(previousVariableBorrowIndex); //calculate the last principal variable debt
        vars.currentVariableDebt = scaledVariableDebt.rayMul(newVariableBorrowIndex);       //calculate the new total supply after accumulation of the index

        //calculate the stable debt until the last timestamp update
        vars.cumulatedStableInterest = MathUtils.calculateCompoundedInterest(vars.avgStableRate, vars.stableSupplyUpdatedTimestamp, timestamp );
        vars.previousStableDebt = vars.principalStableDebt.rayMul(vars.cumulatedStableInterest);

        //debt accrued is the sum of the current debt minus the sum of the debt at the last update
        vars.totalDebtAccrued = vars.currentVariableDebt.add(vars.currentStableDebt).sub(vars.previousVariableDebt).sub(vars.previousStableDebt);
        vars.amountToMint = vars.totalDebtAccrued.percentMul(vars.reserveFactor);

        if (vars.amountToMint != 0) {
            IIToken(instrument.iTokenAddress).mintToTreasury(vars.amountToMint, sighPayAggregator, newLiquidityIndex);
        }
    }

    /**
    * @dev Updates the instrument's reserve indexes and the timestamp of the update
    * @param instrument The instrument reserve to be updated
    * @param scaledVariableDebt The scaled variable debt
    * @param liquidityIndex The last stored liquidity index
    * @param variableBorrowIndex The last stored variable borrow index
    **/
    function _updateIndexes( DataTypes.InstrumentData storage instrument, uint256 scaledVariableDebt, uint256 liquidityIndex, uint256 variableBorrowIndex, uint40 timestamp) internal returns (uint256, uint256) {

        uint256 currentLiquidityRate = instrument.currentLiquidityRate;
        uint256 newLiquidityIndex = liquidityIndex;
        uint256 newVariableBorrowIndex = variableBorrowIndex;

        //only cumulating if there is any income being produced
        if (currentLiquidityRate > 0) {
            uint256 cumulatedLiquidityInterest = MathUtils.calculateLinearInterest(currentLiquidityRate, timestamp);
            newLiquidityIndex = cumulatedLiquidityInterest.rayMul(liquidityIndex);
            require(newLiquidityIndex <= type(uint128).max, Errors.LI_OVRFLW);
            instrument.liquidityIndex = uint128(newLiquidityIndex);

            //as the liquidity rate might come only from stable rate loans, we need to ensure that there is actual variable debt before accumulating
            if (scaledVariableDebt != 0) {
                uint256 cumulatedVariableBorrowInterest = MathUtils.calculateCompoundedInterest(instrument.currentVariableBorrowRate, timestamp);
                newVariableBorrowIndex = cumulatedVariableBorrowInterest.rayMul(variableBorrowIndex);
                require( newVariableBorrowIndex <= type(uint128).max, Errors.VI_OVRFLW );
                instrument.variableBorrowIndex = uint128(newVariableBorrowIndex);
            }
        }

        instrument.lastUpdateTimestamp = uint40(block.timestamp);
        return (newLiquidityIndex, newVariableBorrowIndex);
    }

    function deductFeeOnDeposit(DataTypes.InstrumentData memory instrument, address user, address instrumentAddress, uint amount, address platformFeeCollector, address sighPayAggregator, uint16 _boosterId, address feeProvider ) internal returns(uint) {
        (uint256 totalFee, uint256 platformFee, uint256 reserveFee) = IFeeProviderLendingPool(feeProvider).calculateDepositFee(user,instrumentAddress, amount, _boosterId);
        if (platformFee > 0 && platformFeeCollector != address(0) ) {
            IERC20(instrumentAddress).safeTransferFrom( user, platformFeeCollector, platformFee );
        } else {
            platformFee = 0;
        }
        if (reserveFee > 0 && sighPayAggregator  != address(0) ) {
            IERC20(instrumentAddress).safeTransferFrom( user, sighPayAggregator, reserveFee );
        } else {
            reserveFee = 0;
        }
        emit depositFeeDeducted(instrumentAddress, user, amount, platformFee, reserveFee, _boosterId);
        return totalFee;
    }

    function updateFeeOnBorrow(DataTypes.InstrumentData storage instrument,address user, address instrumentAddress, uint amount,uint16 _boosterId, address feeProvider ) internal {
        (uint platformFee, uint reserveFee) = IFeeProviderLendingPool(feeProvider).calculateBorrowFee(user ,instrumentAddress, amount, _boosterId);
        ISIGHHarvestDebtToken(instrument.stableDebtTokenAddress).updatePlatformFee(user,platformFee,0);
        ISIGHHarvestDebtToken(instrument.stableDebtTokenAddress).updateReserveFee(user,reserveFee,0);
        emit borrowFeeUpdated(user,instrumentAddress, amount, platformFee, reserveFee, _boosterId);
    }

    function updateFeeOnRepay(DataTypes.InstrumentData storage instrument,address user, address onBehalfOf, address instrumentAddress, uint amount, address platformFeeCollector, address sighPayAggregator) internal returns(uint, uint) {
        uint platformFee = ISIGHHarvestDebtToken(instrument.variableDebtTokenAddress).getPlatformFee(onBehalfOf);    // getting platfrom Fee
        uint reserveFee = ISIGHHarvestDebtToken(instrument.variableDebtTokenAddress).getReserveFee(onBehalfOf);     // getting reserve Fee
        uint reserveFeePay; uint platformFeePay;
        // PAY PLATFORM FEE
        if ( platformFee > 0 && platformFeeCollector != address(0) ) {
            platformFeePay =  amount >= platformFee ? platformFee : amount;
            IERC20(instrumentAddress).safeTransferFrom( user, platformFeeCollector, platformFeePay );   // Platform Fee transferred
            amount = amount.sub(platformFeePay);  // Update amount
            ISIGHHarvestDebtToken(instrument.stableDebtTokenAddress).updatePlatformFee(onBehalfOf,0,platformFeePay);
        }
        // PAY RESERVE FEE
        if (reserveFee > 0 && amount > 0 && sighPayAggregator != address(0) ) {
            reserveFeePay =  amount > reserveFee ? reserveFee : amount;
            IERC20(instrumentAddress).safeTransferFrom( user, sighPayAggregator, reserveFeePay );       // Reserve Fee transferred
            amount = amount.sub(reserveFeePay);  // Update payback amount
            ISIGHHarvestDebtToken(instrument.stableDebtTokenAddress).updateReserveFee(onBehalfOf,0,reserveFeePay);
        }

        emit feeRepaid(instrumentAddress,user,onBehalfOf, amount, platformFeePay, reserveFeePay);
        return (amount, platformFeePay.add(reserveFeePay));
    }


  }

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Final Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/LendingPoolStorage.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;




contract LendingPoolStorage {

  using InstrumentReserveLogic for DataTypes.InstrumentData;
  using InstrumentConfiguration for DataTypes.InstrumentConfigurationMap;
  using UserConfiguration for DataTypes.UserConfigurationMap;

  IGlobalAddressesProvider internal addressesProvider;
  address internal feeProvider;

  address internal sighPayAggregator;
  address internal platformFeeCollector;

  mapping(address => DataTypes.InstrumentData) internal _instruments;
  mapping(address => DataTypes.UserConfigurationMap) internal _usersConfig;

  mapping(uint256 => address) internal _instrumentsList;    // the list of the available instruments, structured as a mapping for gas savings reasons
  uint256 internal _instrumentsCount;

  bool internal _paused;
}
