// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Incentives Proposal/incentives-controller-ad534cdedd91d8db5ac1302ef2c200de75377790/contracts/lib/DistributionTypes.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.5;
pragma experimental ABIEncoderV2;

library DistributionTypes {
  struct AssetConfigInput {
    uint104 emissionPerSecond;
    uint256 totalStaked;
    address underlyingAsset;
  }

  struct UserStakeInput {
    address underlyingAsset;
    uint256 stakedByUser;
    uint256 totalStaked;
  }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Incentives Proposal/incentives-controller-ad534cdedd91d8db5ac1302ef2c200de75377790/contracts/interfaces/IAaveDistributionManager.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.5;
pragma experimental ABIEncoderV2;

interface IAaveDistributionManager {
  
  event AssetConfigUpdated(address indexed asset, uint256 emission);
  event AssetIndexUpdated(address indexed asset, uint256 index);
  event UserIndexUpdated(address indexed user, address indexed asset, uint256 index);
  event DistributionEndUpdated(uint256 newDistributionEnd);

  /**
  * @dev Sets the end date for the distribution
  * @param distributionEnd The end date timestamp
  **/
  function setDistributionEnd(uint256 distributionEnd) external;

  /**
  * @dev Gets the end date for the distribution
  * @return The end of the distribution
  **/
  function getDistributionEnd() external view returns (uint256);

  /**
  * @dev for backwards compatibility with the previous DistributionManager used
  * @return The end of the distribution
  **/
  function DISTRIBUTION_END() external view returns(uint256);

   /**
   * @dev Returns the data of an user on a distribution
   * @param user Address of the user
   * @param asset The address of the reference asset of the distribution
   * @return The new index
   **/
   function getUserAssetData(address user, address asset) external view returns (uint256);

   /**
   * @dev Returns the configuration of the distribution for a certain asset
   * @param asset The address of the reference asset of the distribution
   * @return The asset index, the emission per second and the last updated timestamp
   **/
   function getAssetData(address asset) external view returns (uint256, uint256, uint256);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Incentives Proposal/incentives-controller-ad534cdedd91d8db5ac1302ef2c200de75377790/contracts/lib/SafeMath.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.7.5;

/// @title Optimized overflow and underflow safe math operations
/// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
/// inspired by uniswap V3
library SafeMath {
    /// @notice Returns x + y, reverts if sum overflows uint256
    /// @param x The augend
    /// @param y The addend
    /// @return z The sum of x and y
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }

    /// @notice Returns x - y, reverts if underflows
    /// @param x The minuend
    /// @param y The subtrahend
    /// @return z The difference of x and y
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }

    /// @notice Returns x * y, reverts if overflows
    /// @param x The multiplicand
    /// @param y The multiplier
    /// @return z The product of x and y
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(x == 0 || (z = x * y) / x == y);
    }

    function div(uint256 x, uint256 y) internal pure returns(uint256) {
        // no need to check for division by zero - solidity already reverts
        return x / y;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-AAVE-Incentives Proposal/incentives-controller-ad534cdedd91d8db5ac1302ef2c200de75377790/contracts/incentives/DistributionManager.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.5;
pragma experimental ABIEncoderV2;



/**
 * @title DistributionManager
 * @notice Accounting contract to manage multiple staking distributions
 * @author Aave
 **/
contract DistributionManager is IAaveDistributionManager {
  using SafeMath for uint256;

  struct AssetData {
    uint104 emissionPerSecond;
    uint104 index;
    uint40 lastUpdateTimestamp;
    mapping(address => uint256) users;
  }

  address public immutable EMISSION_MANAGER;

  uint8 public constant PRECISION = 18;

  // SWC-Shadowing State Variables: L29
  mapping(address => AssetData) public assets;

  uint256 internal _distributionEnd;

  modifier onlyEmissionManager() {
    require(msg.sender == EMISSION_MANAGER, 'ONLY_EMISSION_MANAGER');
    _;
  }

  constructor(address emissionManager) {
    EMISSION_MANAGER = emissionManager;
  }

  /// @inheritdoc IAaveDistributionManager
  function setDistributionEnd(uint256 distributionEnd) external override onlyEmissionManager {
    _distributionEnd = distributionEnd;
    emit DistributionEndUpdated(distributionEnd);
  }

  /// @inheritdoc IAaveDistributionManager
  function getDistributionEnd() external view override returns (uint256) {
    return _distributionEnd;
  }

  /// @inheritdoc IAaveDistributionManager
  function DISTRIBUTION_END() external view override returns (uint256) {
    return _distributionEnd;
  }

  /// @inheritdoc IAaveDistributionManager
  function getUserAssetData(address user, address asset) public view override returns (uint256) {
    return assets[asset].users[user];
  }

  /// @inheritdoc IAaveDistributionManager
  function getAssetData(address asset) public view override returns (uint256, uint256, uint256) {
    return (assets[asset].index, assets[asset].emissionPerSecond, assets[asset].lastUpdateTimestamp);
  }

  /**
   * @dev Configure the assets for a specific emission
   * @param assetsConfigInput The array of each asset configuration
   **/
  function _configureAssets(DistributionTypes.AssetConfigInput[] memory assetsConfigInput)
    internal
  {
    for (uint256 i = 0; i < assetsConfigInput.length; i++) {
      AssetData storage assetConfig = assets[assetsConfigInput[i].underlyingAsset];

      _updateAssetStateInternal(
        assetsConfigInput[i].underlyingAsset,
        assetConfig,
        assetsConfigInput[i].totalStaked
      );

      assetConfig.emissionPerSecond = assetsConfigInput[i].emissionPerSecond;

      emit AssetConfigUpdated(
        assetsConfigInput[i].underlyingAsset,
        assetsConfigInput[i].emissionPerSecond
      );
    }
  }

  /**
   * @dev Updates the state of one distribution, mainly rewards index and timestamp
   * @param asset The address of the asset being updated
   * @param assetConfig Storage pointer to the distribution's config
   * @param totalStaked Current total of staked assets for this distribution
   * @return The new distribution index
   **/
  function _updateAssetStateInternal(
    address asset,
    AssetData storage assetConfig,
    uint256 totalStaked
  ) internal returns (uint256) {
    uint256 oldIndex = assetConfig.index;
    uint256 emissionPerSecond = assetConfig.emissionPerSecond;
    uint128 lastUpdateTimestamp = assetConfig.lastUpdateTimestamp;

    if (block.timestamp == lastUpdateTimestamp) {
      return oldIndex;
    }

    uint256 newIndex =
      _getAssetIndex(oldIndex, emissionPerSecond, lastUpdateTimestamp, totalStaked);

    if (newIndex != oldIndex) {
      require(uint104(newIndex) == newIndex, 'Index overflow');
      //optimization: storing one after another saves one SSTORE
      assetConfig.index = uint104(newIndex);
      assetConfig.lastUpdateTimestamp = uint40(block.timestamp);
      emit AssetIndexUpdated(asset, newIndex);
    } else {
      assetConfig.lastUpdateTimestamp = uint40(block.timestamp);
    }

    return newIndex;
  }

  /**
   * @dev Updates the state of an user in a distribution
   * @param user The user's address
   * @param asset The address of the reference asset of the distribution
   * @param stakedByUser Amount of tokens staked by the user in the distribution at the moment
   * @param totalStaked Total tokens staked in the distribution
   * @return The accrued rewards for the user until the moment
   **/
  function _updateUserAssetInternal(
    address user,
    address asset,
    uint256 stakedByUser,
    uint256 totalStaked
  ) internal returns (uint256) {
    AssetData storage assetData = assets[asset];
    uint256 userIndex = assetData.users[user];
    uint256 accruedRewards = 0;

    uint256 newIndex = _updateAssetStateInternal(asset, assetData, totalStaked);

    if (userIndex != newIndex) {
      if (stakedByUser != 0) {
        accruedRewards = _getRewards(stakedByUser, newIndex, userIndex);
      }

      assetData.users[user] = newIndex;
      emit UserIndexUpdated(user, asset, newIndex);
    }

    return accruedRewards;
  }

  /**
   * @dev Used by "frontend" stake contracts to update the data of an user when claiming rewards from there
   * @param user The address of the user
   * @param stakes List of structs of the user data related with his stake
   * @return The accrued rewards for the user until the moment
   **/
  function _claimRewards(address user, DistributionTypes.UserStakeInput[] memory stakes)
    internal
    returns (uint256)
  {
    uint256 accruedRewards = 0;

    for (uint256 i = 0; i < stakes.length; i++) {
      accruedRewards = accruedRewards.add(
        _updateUserAssetInternal(
          user,
          stakes[i].underlyingAsset,
          stakes[i].stakedByUser,
          stakes[i].totalStaked
        )
      );
    }

    return accruedRewards;
  }

  /**
   * @dev Return the accrued rewards for an user over a list of distribution
   * @param user The address of the user
   * @param stakes List of structs of the user data related with his stake
   * @return The accrued rewards for the user until the moment
   **/
  function _getUnclaimedRewards(address user, DistributionTypes.UserStakeInput[] memory stakes)
    internal
    view
    returns (uint256)
  {
    uint256 accruedRewards = 0;

    for (uint256 i = 0; i < stakes.length; i++) {
      AssetData storage assetConfig = assets[stakes[i].underlyingAsset];
      uint256 assetIndex =
        _getAssetIndex(
          assetConfig.index,
          assetConfig.emissionPerSecond,
          assetConfig.lastUpdateTimestamp,
          stakes[i].totalStaked
        );

      accruedRewards = accruedRewards.add(
        _getRewards(stakes[i].stakedByUser, assetIndex, assetConfig.users[user])
      );
    }
    return accruedRewards;
  }

  /**
   * @dev Internal function for the calculation of user's rewards on a distribution
   * @param principalUserBalance Amount staked by the user on a distribution
   * @param reserveIndex Current index of the distribution
   * @param userIndex Index stored for the user, representation his staking moment
   * @return The rewards
   **/
  function _getRewards(
    uint256 principalUserBalance,
    uint256 reserveIndex,
    uint256 userIndex
  ) internal pure returns (uint256) {
    return principalUserBalance.mul(reserveIndex.sub(userIndex)) / 10**uint256(PRECISION);
  }

  /**
   * @dev Calculates the next value of an specific distribution index, with validations
   * @param currentIndex Current index of the distribution
   * @param emissionPerSecond Representing the total rewards distributed per second per asset unit, on the distribution
   * @param lastUpdateTimestamp Last moment this distribution was updated
   * @param totalBalance of tokens considered for the distribution
   * @return The new index.
   **/
  function _getAssetIndex(
    uint256 currentIndex,
    uint256 emissionPerSecond,
    uint128 lastUpdateTimestamp,
    uint256 totalBalance
  ) internal view returns (uint256) {
    uint256 distributionEnd = _distributionEnd;
    if (
      emissionPerSecond == 0 ||
      totalBalance == 0 ||
      lastUpdateTimestamp == block.timestamp ||
      lastUpdateTimestamp >= distributionEnd
    ) {
      return currentIndex;
    }

    uint256 currentTimestamp =
      block.timestamp > distributionEnd ? distributionEnd : block.timestamp;
    uint256 timeDelta = currentTimestamp.sub(lastUpdateTimestamp);
    return
      emissionPerSecond.mul(timeDelta).mul(10**uint256(PRECISION)).div(totalBalance).add(
        currentIndex
      );
  }
}
