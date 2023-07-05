// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/SIGHContracts/ISighVolatilityHarvester.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Distribution Handler Contract
 * @notice Handles the SIGH Loss Minimizing Mechanism for the Lending Protocol
 * @dev Accures SIGH for the supported markets based on losses made every 24 hours, along with Staking speeds. This accuring speed is updated every hour
 * @author SIGH Finance
 */

interface ISIGHVolatilityHarvester {

    function refreshConfig() external;

    function addInstrument( address _instrument, address _iTokenAddress,address _stableDebtToken,address _variableDebtToken, address _sighStreamAddress, uint8 _decimals ) external returns (bool);   // onlyLendingPoolCore
    function removeInstrument( address _instrument ) external returns (bool);   //

    function Instrument_SIGH_StateUpdated(address instrument_, uint _bearSentiment,uint _bullSentiment, bool _isSIGHMechanismActivated  ) external returns (bool); // onlySighFinanceConfigurator

    function updateSIGHSpeed(uint SIGHSpeed_) external returns (bool);                                                      // onlySighFinanceConfigurator
    function updateStakingSpeedForAnInstrument(address instrument_, uint newStakingSpeed) external returns (bool);          // onlySighFinanceConfigurator
    function updateCryptoMarketSentiment(  uint cryptoMarketSentiment_ ) external returns (bool);                      // onlySighFinanceConfigurator
    function updateDeltaTimestampRefresh(uint deltaBlocksLimit) external returns (bool);                               // onlySighFinanceConfigurator
    function updateETHOracleAddress( address _EthOracleAddress ) external returns (bool) ;

    function refreshSIGHSpeeds() external returns (bool);

    function updateSIGHSupplyIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPoolCore
    function updateSIGHBorrowIndex(address currentInstrument) external  returns (bool);                                      // onlyLendingPoolCore

    function transferSighTotheUser(address instrument, address user, uint sigh_Amount ) external  returns (uint);             // onlyITokenContract(instrument)

    // ###### VIEW FUNCTIONS ######
    function getSIGHBalance() external view returns (uint);
    function getAllInstrumentsSupported() external view returns (address[] memory );

    function getInstrumentData (address instrument_) external view returns (string memory name, address iTokenAddress, uint decimals, bool isSIGHMechanismActivated,uint256 supplyindex, uint256 borrowindex  );

    function getInstrumentSpeeds(address instrument) external view returns (uint8 side, uint suppliers_speed, uint borrowers_speed, uint staking_speed );
    function getInstrumentVolatilityStates(address instrument) external view returns ( uint8 side, uint _total24HrSentimentVolatility, uint percentTotalSentimentVolatility, uint _total24HrVolatility, uint percentTotalVolatility  );
    function getInstrumentSighLimits(address instrument) external view returns ( uint _bearSentiment , uint _bullSentiment  );

    function getAllPriceSnapshots(address instrument_ ) external view returns (uint256[24] memory);
    function getBlockNumbersForPriceSnapshots() external view returns (uint256[24] memory);

    function getSIGHSpeed() external view returns (uint);
    function getSIGHSpeedUsed() external view returns (uint);

    function isInstrumentSupported (address instrument_) external view returns (bool);
    function totalInstrumentsSupported() external view returns (uint);

    function getInstrumentSupplyIndex(address instrument_) external view returns (uint);
    function getInstrumentBorrowIndex(address instrument_) external view returns (uint);

    function getCryptoMarketSentiment () external view returns (uint);
    function checkPriceSnapshots(address instrument_, uint clock) external view returns (uint256);
    function checkinitializationCounter(address instrument_) external view returns (uint32);

    function getdeltaTimestamp() external view returns (uint);
    function getprevHarvestRefreshTimestamp() external view returns (uint);
    function getBlocksRemainingToNextSpeedRefresh() external view returns (uint);
}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/dependencies/upgradability/VersionedInitializable.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @title VersionedInitializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 *
 * @author Aave, SIGH Finance, inspired by the OpenZeppelin Initializable contract
 */
abstract contract VersionedInitializable {
    /**
   * @dev Indicates that the contract has been initialized.
   */
    uint256 private lastInitializedRevision = 0;

    /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
    bool private initializing;

    /**
   * @dev Modifier to use in the initializer function of a contract.
   */
    modifier initializer() {
        uint256 revision = getRevision();
        require(initializing || isConstructor() || revision > lastInitializedRevision, "Contract instance has already been initialized");

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            lastInitializedRevision = revision;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev returns the revision number of the contract.
    /// Needs to be defined in the inherited class as a constant.
    function getRevision() internal virtual pure returns(uint256);


    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        //solium-disable-next-line
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
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

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/interfaces/SIGHContracts/ISIGHSpeedController.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Speed Controller Contract
 * @notice Distributes a token to a different contract at a fixed rate.
 * @dev This contract must be poked via the `drip()` function every so often.
 * @author _astromartian
 */

interface ISIGHSpeedController {

// #############################################################################################
// ###########   SIGH DISTRIBUTION : INITIALIZED DRIPPING (Can be called only once)   ##########
// #############################################################################################

  function beginDripping () external returns (bool);
  function updateSighVolatilityDistributionSpeed(uint newSpeed) external returns (bool);

// ############################################################################################################
// ###########   SIGH DISTRIBUTION : ADDING / REMOVING NEW PROTOCOL WHICH WILL RECEIVE SIGH TOKENS   ##########
// ############################################################################################################

  function supportNewProtocol( address newProtocolAddress, uint sighSpeedRatio ) external returns (bool);
  function updateProtocolState(address _protocolAddress, bool isSupported_, uint newRatio_) external  returns (bool);

// #####################################################################
// ###########   SIGH DISTRIBUTION FUNCTION - DRIP FUNCTION   ##########
// #####################################################################

  function drip() external ;

// ###############################################################
// ###########   EXTERNAL VIEW functions TO GET STATE   ##########
// ###############################################################

  function getGlobalAddressProvider() external view returns (address);
  function getSighAddress() external view returns (address);
  function getSighVolatilityHarvester() external view returns (address);

  function getSIGHBalance() external view returns (uint);
  function getSIGHVolatilityHarvestingSpeed() external view returns (uint);

  function getSupportedProtocols() external view returns (address[] memory);
  function isThisProtocolSupported(address protocolAddress) external view returns (bool);
  function getSupportedProtocolState(address protocolAddress) external view returns (bool isSupported,
                                                                                    uint sighHarvestingSpeedRatio,
                                                                                    uint totalDrippedAmount,
                                                                                    uint recentlyDrippedAmount );
  function getTotalAmountDistributedToProtocol(address protocolAddress) external view returns (uint);
  function getRecentAmountDistributedToProtocol(address protocolAddress) external view returns (uint);
  function getSIGHSpeedRatioForProtocol(address protocolAddress) external view returns (uint);
  function totalProtocolsSupported() external view returns (uint);

  function _isDripAllowed() external view returns (bool);
  function getlastDripBlockNumber() external view returns (uint);

}

// File: ../sc_datasets/DAppSCAN/ImmuneBytes-SIGH Finance-Audit Report/SIGH-Finance-Contracts-9feee84e18cabb4015ca60dc016340f2c94af27a/SIGHFinanceContracts/contracts/SIGHContracts/SIGHSpeedController.sol

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.7.0;

/**
 * @title Sigh Speed Controller Contract
 * @notice Distributes a token to a different contract at a fixed rate.
 * @dev This contract must be poked via the `drip()` function every so often.
 * @author _astromartian
 */





contract SIGHSpeedController is ISIGHSpeedController, VersionedInitializable  {

  IGlobalAddressesProvider private addressesProvider;

  IERC20 private sighInstrument;                                         // SIGH INSTRUMENT CONTRACT

  bool private isDripAllowed = false;
  uint private lastDripBlockNumber;

   ISIGHVolatilityHarvester private sighVolatilityHarvester;      // SIGH DISTRIBUTION HANDLER CONTRACT
   uint256 private sighVolatilityHarvestingSpeed;
   uint private totalDrippedToVolatilityHarvester;                 // TOTAL $SIGH DRIPPED TO SIGH VOLATILTIY HARVESTER
   uint private recentlyDrippedToVolatilityHarvester;              // $SIGH RECENTLY DRIPPED TO SIGH VOLATILTIY HARVESTER

  struct protocolState {
    bool isSupported;
    Exp sighSpeedRatio;
    uint totalDrippedAmount;
    uint recentlyDrippedAmount;
  }

  address[] private storedSupportedProtocols;
  mapping (address => protocolState) private supportedProtocols;


    struct Exp {
        uint mantissa;
    }

    uint private expScale = 1e18;

// ########################
// ####### EVENTS #########
// ########################

  event DistributionInitialized(address sighVolatilityHarvesterAddress);

  event SighVolatilityHarvestsSpeedUpdated(uint newSIGHDistributionSpeed );

  event NewProtocolSupported (address protocolAddress, uint sighSpeedRatio, uint totalDrippedAmount);
  event ProtocolUpdated(address _protocolAddress, bool _isSupported , uint _sighSpeedRatio);

  event DrippedToVolatilityHarvester(address sighVolatilityHarvesterAddress,uint deltaBlocks,uint harvestDistributionSpeed,uint recentlyDrippedToVolatilityHarvester ,uint totalDrippedToVolatilityHarvester);
  event Dripped(address protocolAddress, uint deltaBlocks, uint sighSpeedRatio, uint distributionSpeed, uint AmountDripped, uint totalAmountDripped);

// ########################
// ####### MODIFIER #######
// ########################

    //only SIGH Finance Configurator can use functions affected by this modifier
    modifier onlySighFinanceConfigurator {
        require(addressesProvider.getSIGHFinanceConfigurator() == msg.sender, "The caller must be SIGH Finance Configurator Contract");
        _;
    }

// ###########################
// ####### CONSTRUCTOR #######
// ###########################

    uint256 public constant REVISION = 0x1;             // NEEDED AS PART OF UPGRADABLE CONTRACTS FUNCTIONALITY ( VersionedInitializable )

    function getRevision() internal override pure returns (uint256) {        // NEEDED AS PART OF UPGRADABLE CONTRACTS FUNCTIONALITY ( VersionedInitializable )
        return REVISION;
    }

    /**
    * @dev this function is invoked by the proxy contract when the LendingPool contract is added to the AddressesProvider.
    * @param _addressesProvider the address of the GlobalAddressesProvider registry
    **/
    function initialize(IGlobalAddressesProvider _addressesProvider) public initializer {
        addressesProvider = _addressesProvider;
        refreshConfigInternal();
    }

  function refreshConfigInternal() internal {
    require(address(addressesProvider) != address(0), " AddressesProvider not initialized Properly ");
    sighInstrument = IERC20(addressesProvider.getSIGHAddress());
    require(address(sighInstrument) != address(0), " SIGH Instrument not initialized Properly ");
  }


// #############################################################################################
// ###########   SIGH DISTRIBUTION : INITIALIZED DRIPPING (Can be called only once)   ##########
// #############################################################################################

  function beginDripping () external override onlySighFinanceConfigurator returns (bool) {
    require(!isDripAllowed,"Dripping can only be initialized once");
    address sighVolatilityHarvesterAddress_ = addressesProvider.getSIGHVolatilityHarvester();
    require(sighVolatilityHarvesterAddress_ != address(0),"SIGH Volatility Harvester Address not valid");

    isDripAllowed = true;
    sighVolatilityHarvester = ISIGHVolatilityHarvester(sighVolatilityHarvesterAddress_);
    lastDripBlockNumber = block.number;

    emit DistributionInitialized( sighVolatilityHarvesterAddress_);
    return true;
  }

  function updateSighVolatilityDistributionSpeed(uint newSpeed) external override onlySighFinanceConfigurator returns (bool) {
    sighVolatilityHarvestingSpeed = newSpeed;
    emit SighVolatilityHarvestsSpeedUpdated( sighVolatilityHarvestingSpeed );
    return true;
  }

// ############################################################################################################
// ###########   SIGH DISTRIBUTION : ADDING / REMOVING NEW PROTOCOL WHICH WILL RECEIVE SIGH INSTRUMENTS   ##########
// ############################################################################################################

  function supportNewProtocol( address newProtocolAddress, uint sighSpeedRatio ) external override onlySighFinanceConfigurator returns (bool)  {
    require (!supportedProtocols[newProtocolAddress].isSupported, 'Already supported');
    require (  sighSpeedRatio == 0 || ( 0.01e18 <= sighSpeedRatio && sighSpeedRatio <= 2e18 ), "Invalid SIGH Speed Ratio");


    if (isDripAllowed) {
        dripInternal();
        dripToVolatilityHarvesterInternal();
        lastDripBlockNumber = block.number;
    }

    if ( supportedProtocols[newProtocolAddress].totalDrippedAmount > 0 ) {
        supportedProtocols[newProtocolAddress].isSupported = true;
        supportedProtocols[newProtocolAddress].sighSpeedRatio = Exp({ mantissa: sighSpeedRatio });
    }
    else {
        storedSupportedProtocols.push(newProtocolAddress);                              // ADDED TO THE LIST
        supportedProtocols[newProtocolAddress] = protocolState({ isSupported: true, sighSpeedRatio: Exp({ mantissa: sighSpeedRatio }), totalDrippedAmount: uint(0), recentlyDrippedAmount: uint(0) });
    }

    require (supportedProtocols[newProtocolAddress].isSupported, 'Error occured when adding the new protocol');
    require (supportedProtocols[newProtocolAddress].sighSpeedRatio.mantissa == sighSpeedRatio, 'Speed Ratio not initialized properly.');

    emit NewProtocolSupported(newProtocolAddress, supportedProtocols[newProtocolAddress].sighSpeedRatio.mantissa, supportedProtocols[newProtocolAddress].totalDrippedAmount);
    return true;
  }

// ######################################################################################
// ###########   SIGH DISTRIBUTION : FUNCTIONS TO UPDATE DISTRIBUTION SPEEDS   ##########
// ######################################################################################

  function updateProtocolState (address _protocolAddress, bool isSupported_, uint newRatio_) external override onlySighFinanceConfigurator returns (bool) {
    require (  newRatio_ == 0 || ( 0.01e18 <= newRatio_ && newRatio_ <= 2e18 ), "Invalid Speed Ratio");
    address[] memory protocols = storedSupportedProtocols;
    bool counter = false;

    for (uint i; i < protocols.length;i++) {
        if ( _protocolAddress == protocols[i] ) {
            counter = true;
            break;
        }
    }
    require(counter,'Protocol not supported');

    if (isDripAllowed) {
        dripInternal();
        dripToVolatilityHarvesterInternal();
        lastDripBlockNumber = block.number;
    }

    supportedProtocols[_protocolAddress].isSupported = isSupported_;
    supportedProtocols[_protocolAddress].sighSpeedRatio.mantissa = newRatio_;
    require(supportedProtocols[_protocolAddress].sighSpeedRatio.mantissa == newRatio_, "SIGH Volatiltiy harvesting - Speed Ratio was not properly updated");

    emit ProtocolUpdated(_protocolAddress, supportedProtocols[_protocolAddress].isSupported , supportedProtocols[_protocolAddress].sighSpeedRatio.mantissa);
    return true;
  }


// #####################################################################
// ###########   SIGH DISTRIBUTION FUNCTION - DRIP FUNCTION   ##########
// #####################################################################

  /**
    * @notice Drips the maximum amount of sighInstruments to match the drip rate since inception
    * @dev Note: this will only drip up to the amount of sighInstruments available.
    */
  function drip() override public {
    require(isDripAllowed,'Dripping has not been initialized by the SIGH Finance Manager');
    dripInternal();
    dripToVolatilityHarvesterInternal();
    lastDripBlockNumber = block.number;
  }

  function dripToVolatilityHarvesterInternal() internal {
    if ( address(sighVolatilityHarvester) == address(0) || lastDripBlockNumber == block.number ) {
      return;
    }

    uint blockNumber_ = block.number;
    uint reservoirBalance_ = sighInstrument.balanceOf(address(this));
    uint deltaBlocks = sub(blockNumber_,lastDripBlockNumber,"Delta Blocks gave error");

    uint deltaDrip_ = mul(sighVolatilityHarvestingSpeed, deltaBlocks , "dripTotal overflow");
    uint toDrip_ = min(reservoirBalance_, deltaDrip_);

    require(reservoirBalance_ != 0, 'Transfer: The reservoir currently does not have any SIGH' );
    require(sighInstrument.transfer(address(sighVolatilityHarvester), toDrip_), 'Protocol Transfer: The transfer did not complete.' );

    totalDrippedToVolatilityHarvester = add(totalDrippedToVolatilityHarvester,toDrip_,"Overflow");
    recentlyDrippedToVolatilityHarvester = toDrip_;

    emit DrippedToVolatilityHarvester( address(sighVolatilityHarvester), deltaBlocks, sighVolatilityHarvestingSpeed, recentlyDrippedToVolatilityHarvester , totalDrippedToVolatilityHarvester);
  }


  function dripInternal() internal {

    if (lastDripBlockNumber == block.number) {
        return;
    }

    address[] memory protocols = storedSupportedProtocols;
    uint length = protocols.length;

    uint currentVolatilityHarvestSpeed = sighVolatilityHarvester.getSIGHSpeedUsed();
    uint reservoirBalance_;

    uint blockNumber_ = block.number;
    uint deltaBlocks = sub(blockNumber_,lastDripBlockNumber,"Delta Blocks gave error");

    if (length > 0 && currentVolatilityHarvestSpeed > 0) {

        for ( uint i=0; i < length; i++) {
            address current_protocol = protocols[i];

            if ( supportedProtocols[ current_protocol ].isSupported ) {

                reservoirBalance_ = sighInstrument.balanceOf(address(this));
                uint distributionSpeed = mul_(currentVolatilityHarvestSpeed, supportedProtocols[current_protocol].sighSpeedRatio );       // current Harvest Speed * Ratio / 1e18
                uint deltaDrip_ = mul(distributionSpeed, deltaBlocks , "dripTotal overflow");
                uint toDrip_ = min(reservoirBalance_, deltaDrip_);

                require(reservoirBalance_ != 0, 'Transfer: The reservoir currently does not have any SIGH Instruments' );
                require(sighInstrument.transfer(current_protocol, toDrip_), 'Transfer: The transfer did not complete.' );

                supportedProtocols[current_protocol].totalDrippedAmount = add(supportedProtocols[current_protocol].totalDrippedAmount , toDrip_,"Overflow");
                supportedProtocols[current_protocol].recentlyDrippedAmount = toDrip_;

                emit Dripped( current_protocol, deltaBlocks, supportedProtocols[ current_protocol ].sighSpeedRatio.mantissa, distributionSpeed , toDrip_ , supportedProtocols[current_protocol].totalDrippedAmount );
            }
        }
    }

  }




// ###############################################################
// ###########   EXTERNAL VIEW functions TO GET STATE   ##########
// ###############################################################

  function getSighAddress() external override view returns (address) {
    return address(sighInstrument);
  }

  function getGlobalAddressProvider() external override view returns (address) {
    return address(addressesProvider);
  }

  function getSighVolatilityHarvester() external override view returns (address) {
    return address(sighVolatilityHarvester);
  }

  function getSIGHVolatilityHarvestingSpeed() external override view returns (uint) {
    return sighVolatilityHarvestingSpeed;
  }

  function getSIGHBalance() external override view returns (uint) {
    uint balance = sighInstrument.balanceOf(address(this));
    return balance;
  }

  function getSupportedProtocols() external override view returns (address[] memory) {
    return storedSupportedProtocols;
  }

  function isThisProtocolSupported(address protocolAddress) external override view returns (bool) {
    if (protocolAddress == address(sighVolatilityHarvester) ) {
        return true;
    }
    return supportedProtocols[protocolAddress].isSupported;
  }

  function getSupportedProtocolState(address protocolAddress) external override view returns (bool isSupported,uint sighHarvestingSpeedRatio,uint totalDrippedAmount,uint recentlyDrippedAmount ) {
    if (protocolAddress == address(sighVolatilityHarvester) ) {
        return (true, 1e18,totalDrippedToVolatilityHarvester,recentlyDrippedToVolatilityHarvester  );
    }

  return (supportedProtocols[protocolAddress].isSupported,
          supportedProtocols[protocolAddress].sighSpeedRatio.mantissa,
          supportedProtocols[protocolAddress].totalDrippedAmount,
          supportedProtocols[protocolAddress].recentlyDrippedAmount  );

  }

  function getTotalAmountDistributedToProtocol(address protocolAddress) external override view returns (uint) {
    if (protocolAddress == address(sighVolatilityHarvester) ) {
        return totalDrippedToVolatilityHarvester;
    }
    return supportedProtocols[protocolAddress].totalDrippedAmount;
  }

  function getRecentAmountDistributedToProtocol(address protocolAddress) external override view returns (uint) {
    if (protocolAddress == address(sighVolatilityHarvester) ) {
        return recentlyDrippedToVolatilityHarvester;
    }
    return supportedProtocols[protocolAddress].recentlyDrippedAmount;
  }

  function getSIGHSpeedRatioForProtocol(address protocolAddress) external override view returns (uint) {
    if (protocolAddress == address(sighVolatilityHarvester) ) {
        return 1e18;
    }
      return supportedProtocols[protocolAddress].sighSpeedRatio.mantissa;
  }

  function totalProtocolsSupported() external override view returns (uint) {
      uint len = storedSupportedProtocols.length;
      return len + 1;
  }


  function _isDripAllowed() external override view returns (bool) {
      return isDripAllowed;
  }

  function getlastDripBlockNumber() external override view returns (uint) {
      return lastDripBlockNumber;
  }

// ###############################################################
// ########### Internal helper functions for safe math ###########
// ###############################################################

  function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
    uint c = a + b;
    require(c >= a, errorMessage);
    return c;
  }

  function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
    require(b <= a, errorMessage);
    uint c = a - b;
    return c;
  }

  function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b, errorMessage);
    return c;
  }

  function mul_(uint a, Exp memory b) internal view  returns (uint) {
      return mul(a, b.mantissa,'Exp multiplication failed') / expScale;
  }


  function min(uint a, uint b) internal pure returns (uint) {
    if (a <= b) {
      return a;
    } else {
      return b;
    }
  }
}
