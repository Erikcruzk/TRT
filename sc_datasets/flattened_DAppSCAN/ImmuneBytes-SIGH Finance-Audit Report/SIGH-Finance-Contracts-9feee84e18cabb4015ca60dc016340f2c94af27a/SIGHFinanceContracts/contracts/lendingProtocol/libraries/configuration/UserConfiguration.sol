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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/lendingProtocol/libraries/configuration/UserConfiguration.sol

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
