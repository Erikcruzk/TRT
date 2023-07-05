// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/IPriceOracleGetter.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title IPriceOracleGetter interface
 * @notice Interface for the SIGH Finance price oracle.
 **/

interface IPriceOracleGetter {

  /**
   * @dev returns the asset price in USD
   * @param asset the address of the asset
   * @return the USD price of the asset
   **/
  function getAssetPrice(address asset) external view returns (uint256);

  /**
   * @dev returns the decimals correction of the USD price
   * @param asset the address of the asset
   * @return  the decimals correction of the USD price
   **/
  function getAssetPriceDecimals(address asset) external view returns (uint8);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/GlobalAddressesProvider/IGlobalAddressesProvider.sol

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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/IAggregatorV2V3Interface.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

interface IAggregatorV2V3Interface {

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function version() external view returns (uint256);

  function latestAnswer() external view returns (int256);
  function latestTimestamp() external view returns (uint256);
  function latestRound() external view returns (uint256);
  function getAnswer(uint256 roundId) external view returns (int256);
  function getTimestamp(uint256 roundId) external view returns (uint256);

  // getRoundData and latestRoundData should both raise "No data present"
  // if they do not have data to report, instead of returning unset values
  // which could be misinterpreted as actual reported values.
  function getRoundData(uint80 _roundId) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
  function latestRoundData() external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/mocks/MockProxyPriceProvider.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;



/// @title ChainlinkProxyPriceProvider
/// @author Aave, SIGH Finance
/// @notice Proxy smart contract to get the price of an asset from a price source, with Chainlink Aggregator smart contracts as primary option
/// - If the returned price by a Chainlink aggregator is <= 0, the call is forwarded to a fallbackOracle

contract MockProxyPriceProvider is IPriceOracleGetter {

    IGlobalAddressesProvider public globalAddressesProvider;

    mapping(address => uint) assetPrices;

    mapping(address => IAggregatorV2V3Interface) private assetsSources;
    IPriceOracleGetter private fallbackOracle;

    event AssetSourceUpdated(address indexed asset, address indexed source);
    event FallbackOracleUpdated(address indexed fallbackOracle);

    modifier onlyLendingPoolManager {
        require(msg.sender == globalAddressesProvider.getLendingPoolManager(),"New Source / fallback oracle can only be set by the LendingPool Manager.");
        _;
    }

// #######################
// ##### CONSTRUCTOR #####
// #######################

    constructor( address globalAddressesProvider_ ) {
        globalAddressesProvider = IGlobalAddressesProvider(globalAddressesProvider_);
    }

// ####################################
// ##### SET THE PRICEFEED SOURCE #####
// ####################################

    function supportNewAsset(address asset_, uint price) public  {  //
        assetPrices[asset_] = price;
    }

//    /// @notice External function called by the Aave governance to set or replace sources of assets
//    /// @param _assets The addresses of the assets
//    /// @param _sources The address of the source of each asset
//    function setAssetSources(address[] calldata _assets, address[] calldata _sources) external onlyLendingPoolManager {
//        internalSetAssetsSources(_assets, _sources);
//    }

//    /// @notice Sets the fallbackOracle
//    /// - Callable only by the Aave governance
//    /// @param _fallbackOracle The address of the fallbackOracle
//    function setFallbackOracle(address _fallbackOracle) onlyLendingPoolManager external  {  //
//        internalSetFallbackOracle(_fallbackOracle);
//    }

// ##############################
// ##### INTERNAL FUNCTIONS #####
// ##############################

    /// @notice Internal function to set the sources for each asset
    /// @param _assets The addresses of the assets
    /// @param _sources The address of the source of each asset
    function internalSetAssetsSources(address[] memory _assets, address[] memory _sources) internal {
        require(_assets.length == _sources.length, "INCONSISTENT_PARAMS_LENGTH");
        for (uint256 i = 0; i < _assets.length; i++) {
            assetsSources[_assets[i]] = IAggregatorV2V3Interface(_sources[i]);
            emit AssetSourceUpdated(_assets[i], _sources[i]);
        }
    }

    /// @notice Internal function to set the fallbackOracle
    /// @param _fallbackOracle The address of the fallbackOracle
    function internalSetFallbackOracle(address _fallbackOracle) internal {
        fallbackOracle = IPriceOracleGetter(_fallbackOracle);
        emit FallbackOracleUpdated(_fallbackOracle);
    }

// ##########################
// ##### VIEW FUNCTIONS #####
// ##########################

    /// @notice Gets an asset price by address
    /// @param _asset The asset address
    function getAssetPrice(address _asset) public view override returns(uint256) {
        return assetPrices[_asset];
//        IAggregatorV2V3Interface source = assetsSources[_asset];
//        if (address(source) == address(0)) {                // If there is no registered source for the asset, call the fallbackOracle
//            return IPriceOracleGetter(fallbackOracle).getAssetPrice(_asset);
//        }
//        else {
//            int256 _price = IAggregatorV2V3Interface(source).latestAnswer();
//            if (_price > 0) {
//                return uint256(_price);
//            }
//            else {
//                return IPriceOracleGetter(fallbackOracle).getAssetPrice(_asset);
//            }
//        }
    }

    function getAssetPriceDecimals (address _asset) external view override returns(uint8) {
        return uint8(18);
//        IAggregatorV2V3Interface source = assetsSources[_asset];
//        uint8 decimals = IAggregatorV2V3Interface(source).decimals();
//        return decimals;
    }

    /// @notice Gets a list of prices from a list of assets addresses
    /// @param _assets The list of assets addresses
    function getAssetsPrices(address[] calldata _assets) external view returns(uint256[] memory) {
        uint256[] memory prices = new uint256[](_assets.length);
        for (uint256 i = 0; i < _assets.length; i++) {
            prices[i] = getAssetPrice(_assets[i]);
        }
        return prices;
    }

    /// @notice Gets the address of the source for an asset address
    /// @param _asset The address of the asset
    /// @return address The address of the source
    function getSourceOfAsset(address _asset) external view returns(address) {
        return address(assetsSources[_asset]);
    }

    /// @notice Gets the address of the fallback oracle
    /// @return address The addres of the fallback oracle
    function getFallbackOracle() external view returns(address) {
        return address(fallbackOracle);
    }
}
