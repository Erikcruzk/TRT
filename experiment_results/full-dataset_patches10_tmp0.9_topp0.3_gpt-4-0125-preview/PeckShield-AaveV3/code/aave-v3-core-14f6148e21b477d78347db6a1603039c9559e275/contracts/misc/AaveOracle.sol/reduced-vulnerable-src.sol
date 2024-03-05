


pragma solidity 0.8.7;






interface IACLManager {
  function POOL_ADMIN_ROLE() external view returns (bytes32);

  function EMERGENCY_ADMIN_ROLE() external view returns (bytes32);

  function RISK_ADMIN_ROLE() external view returns (bytes32);

  function FLASH_BORROWER_ROLE() external view returns (bytes32);

  function BRIDGE_ROLE() external view returns (bytes32);

  function ASSET_LISTING_ADMIN_ROLE() external view returns (bytes32);

  





  function setRoleAdmin(bytes32 role, bytes32 adminRole) external;

  



  function addPoolAdmin(address admin) external;

  



  function removePoolAdmin(address admin) external;

  




  function isPoolAdmin(address admin) external view returns (bool);

  



  function addEmergencyAdmin(address admin) external;

  



  function removeEmergencyAdmin(address admin) external;

  




  function isEmergencyAdmin(address admin) external view returns (bool);

  



  function addRiskAdmin(address admin) external;

  



  function removeRiskAdmin(address admin) external;

  




  function isRiskAdmin(address admin) external view returns (bool);

  



  function addFlashBorrower(address borrower) external;

  



  function removeFlashBorrower(address borrower) external;

  




  function isFlashBorrower(address borrower) external view returns (bool);

  



  function addBridge(address bridge) external;

  



  function removeBridge(address bridge) external;

  




  function isBridge(address bridge) external view returns (bool);

  



  function addAssetListingAdmin(address admin) external;

  



  function removeAssetListingAdmin(address admin) external;

  




  function isAssetListingAdmin(address admin) external view returns (bool);
}




pragma solidity 0.8.7;






interface IPoolAddressesProvider {
  event MarketIdSet(string newMarketId);
  event PoolUpdated(address indexed newAddress);
  event PoolConfiguratorUpdated(address indexed newAddress);
  event PriceOracleUpdated(address indexed newAddress);
  event ACLManagerUpdated(address indexed newAddress);
  event ACLAdminUpdated(address indexed newAddress);
  event PriceOracleSentinelUpdated(address indexed newAddress);
  event ProxyCreated(bytes32 id, address indexed newAddress);
  event BridgeAccessControlUpdated(address indexed newAddress);
  event PoolDataProviderUpdated(address indexed newAddress);
  event AddressSet(bytes32 id, address indexed newAddress, bool hasProxy);

  



  function getMarketId() external view returns (string memory);

  



  function setMarketId(string calldata marketId) external;

  





  function setAddress(bytes32 id, address newAddress) external;

  








  function setAddressAsProxy(bytes32 id, address impl) external;

  



  function getAddress(bytes32 id) external view returns (address);

  



  function getPool() external view returns (address);

  




  function setPoolImpl(address pool) external;

  



  function getPoolConfigurator() external view returns (address);

  




  function setPoolConfiguratorImpl(address configurator) external;

  function getPriceOracle() external view returns (address);

  function setPriceOracle(address priceOracle) external;

  



  function getACLManager() external view returns (address);

  



  function setACLManager(address aclManager) external;

  



  function getACLAdmin() external view returns (address);

  



  function setACLAdmin(address aclAdmin) external;

  



  function getPriceOracleSentinel() external view returns (address);

  



  function setPriceOracleSentinel(address oracleSentinel) external;

  



  function setPoolDataProvider(address dataProvider) external;

  



  function getPoolDataProvider() external view returns (address);
}




pragma solidity 0.8.7;






interface IPriceOracleGetter {
  



  function BASE_CURRENCY() external view returns (address);

  



  function BASE_CURRENCY_UNIT() external view returns (uint256);

  




  function getAssetPrice(address asset) external view returns (uint256);
}




pragma solidity 0.8.7;

interface IChainlinkAggregator {
  function latestAnswer() external view returns (int256);

  function latestTimestamp() external view returns (uint256);

  function latestRound() external view returns (uint256);

  function getAnswer(uint256 roundId) external view returns (int256);

  function getTimestamp(uint256 roundId) external view returns (uint256);

  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
  event NewRound(uint256 indexed roundId, address indexed startedBy);
}




pragma solidity 0.8.7;


















library Errors {
  
  string public constant CALLER_NOT_POOL_ADMIN = '33'; 

  
  string public constant VL_INVALID_AMOUNT = '1'; 
  string public constant VL_NO_ACTIVE_RESERVE = '2'; 
  string public constant VL_RESERVE_FROZEN = '3'; 
  string public constant VL_CURRENT_AVAILABLE_LIQUIDITY_NOT_ENOUGH = '4'; 
  string public constant VL_NOT_ENOUGH_AVAILABLE_USER_BALANCE = '5'; 
  string public constant VL_BORROWING_NOT_ENABLED = '7'; 
  string public constant VL_INVALID_INTEREST_RATE_MODE_SELECTED = '8'; 
  string public constant VL_COLLATERAL_BALANCE_IS_0 = '9'; 
  string public constant VL_HEALTH_FACTOR_LOWER_THAN_LIQUIDATION_THRESHOLD = '10'; 
  string public constant VL_COLLATERAL_CANNOT_COVER_NEW_BORROW = '11'; 
  string public constant VL_STABLE_BORROWING_NOT_ENABLED = '12'; 
  string public constant VL_COLLATERAL_SAME_AS_BORROWING_CURRENCY = '13'; 
  string public constant VL_AMOUNT_BIGGER_THAN_MAX_LOAN_SIZE_STABLE = '14'; 
  string public constant VL_NO_DEBT_OF_SELECTED_TYPE = '15'; 
  string public constant VL_NO_EXPLICIT_AMOUNT_TO_REPAY_ON_BEHALF = '16'; 
  string public constant VL_NO_STABLE_RATE_LOAN_IN_RESERVE = '17'; 
  string public constant VL_NO_VARIABLE_RATE_LOAN_IN_RESERVE = '18'; 
  string public constant VL_UNDERLYING_BALANCE_NOT_GREATER_THAN_0 = '19'; 
  string public constant VL_SUPPLIED_ASSETS_ALREADY_IN_USE = '20'; 
  string public constant P_NOT_ENOUGH_STABLE_BORROW_BALANCE = '21'; 
  string public constant P_INTEREST_RATE_REBALANCE_CONDITIONS_NOT_MET = '22'; 
  string public constant P_LIQUIDATION_CALL_FAILED = '23'; 
  string public constant P_NOT_ENOUGH_LIQUIDITY_TO_BORROW = '24'; 
  string public constant P_REQUESTED_AMOUNT_TOO_SMALL = '25'; 
  string public constant P_INCONSISTENT_PROTOCOL_ACTUAL_BALANCE = '26'; 
  string public constant P_CALLER_NOT_POOL_CONFIGURATOR = '27'; 
  string public constant P_INCONSISTENT_FLASHLOAN_PARAMS = '28';
  string public constant CT_CALLER_MUST_BE_POOL = '29'; 
  string public constant CT_CANNOT_GIVE_ALLOWANCE_TO_HIMSELF = '30'; 
  string public constant CT_TRANSFER_AMOUNT_NOT_GT_0 = '31'; 
  string public constant RL_RESERVE_ALREADY_INITIALIZED = '32'; 
  string public constant PC_RESERVE_LIQUIDITY_NOT_0 = '34'; 
  string public constant PC_INVALID_ATOKEN_POOL_ADDRESS = '35'; 
  string public constant PC_INVALID_STABLE_DEBT_TOKEN_POOL_ADDRESS = '36'; 
  string public constant PC_INVALID_VARIABLE_DEBT_TOKEN_POOL_ADDRESS = '37'; 
  string public constant PC_INVALID_STABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '38'; 
  string public constant PC_INVALID_VARIABLE_DEBT_TOKEN_UNDERLYING_ADDRESS = '39'; 
  string public constant PC_INVALID_ADDRESSES_PROVIDER_ID = '40'; 
  string public constant PC_INVALID_CONFIGURATION = '75'; 
  string public constant PC_CALLER_NOT_EMERGENCY_ADMIN = '76'; 
  string public constant PAPR_PROVIDER_NOT_REGISTERED = '41'; 
  string public constant VL_HEALTH_FACTOR_NOT_BELOW_THRESHOLD = '42'; 
  string public constant VL_COLLATERAL_CANNOT_BE_LIQUIDATED = '43'; 
  string public constant VL_SPECIFIED_CURRENCY_NOT_BORROWED_BY_USER = '44'; 
  string public constant VL_NOT_ENOUGH_LIQUIDITY_TO_LIQUIDATE = '45'; 
  string public constant P_INVALID_FLASHLOAN_MODE = '47'; 
  string public constant MATH_MULTIPLICATION_OVERFLOW = '48';
  string public constant MATH_ADDITION_OVERFLOW = '49';
  string public constant MATH_DIVISION_BY_ZERO = '50';
  string public constant CT_INVALID_MINT_AMOUNT = '56'; 
  string public constant CT_INVALID_BURN_AMOUNT = '58'; 
  string public constant P_REENTRANCY_NOT_ALLOWED = '62';
  string public constant P_CALLER_MUST_BE_AN_ATOKEN = '63';
  string public constant P_IS_PAUSED = '64'; 
  string public constant P_NO_MORE_RESERVES_ALLOWED = '65';
  string public constant P_INVALID_FLASH_LOAN_EXECUTOR_RETURN = '66';
  string public constant RC_INVALID_LTV = '67';
  string public constant RC_INVALID_LIQ_THRESHOLD = '68';
  string public constant RC_INVALID_LIQ_BONUS = '69';
  string public constant RC_INVALID_DECIMALS = '70';
  string public constant RC_INVALID_RESERVE_FACTOR = '71';
  string public constant PAPR_INVALID_ADDRESSES_PROVIDER_ID = '72';
  string public constant VL_INCONSISTENT_FLASHLOAN_PARAMS = '73';
  string public constant P_INCONSISTENT_PARAMS_LENGTH = '74';
  string public constant UL_INVALID_INDEX = '77';
  string public constant P_NOT_CONTRACT = '78';
  string public constant SDT_STABLE_DEBT_OVERFLOW = '79'; 
  string public constant SDT_BURN_EXCEEDS_BALANCE = '80';
  string public constant VL_BORROW_CAP_EXCEEDED = '81';
  string public constant RC_INVALID_BORROW_CAP = '82';
  string public constant VL_SUPPLY_CAP_EXCEEDED = '83';
  string public constant RC_INVALID_SUPPLY_CAP = '84';
  string public constant PC_CALLER_NOT_EMERGENCY_OR_POOL_ADMIN = '85';
  string public constant VL_RESERVE_PAUSED = '86';
  string public constant PC_CALLER_NOT_RISK_OR_POOL_ADMIN = '87';
  string public constant RL_ATOKEN_SUPPLY_NOT_ZERO = '88';
  string public constant RL_STABLE_DEBT_NOT_ZERO = '89';
  string public constant RL_VARIABLE_DEBT_SUPPLY_NOT_ZERO = '90';
  string public constant VL_LTV_VALIDATION_FAILED = '93';
  string public constant VL_SAME_BLOCK_BORROW_REPAY = '94';
  string public constant PC_FLASHLOAN_PREMIUMS_MISMATCH = '95';
  string public constant PC_FLASHLOAN_PREMIUM_INVALID = '96';
  string public constant RC_INVALID_LIQUIDATION_PROTOCOL_FEE = '97';
  string public constant RC_INVALID_EMODE_CATEGORY = '98';
  string public constant VL_INCONSISTENT_EMODE_CATEGORY = '99';
  string public constant HLP_UINT128_OVERFLOW = '100';
  string public constant PC_CALLER_NOT_ASSET_LISTING_OR_POOL_ADMIN = '101';
  string public constant P_CALLER_NOT_BRIDGE = '102';
  string public constant RC_INVALID_UNBACKED_MINT_CAP = '103';
  string public constant VL_UNBACKED_MINT_CAP_EXCEEDED = '104';
  string public constant VL_PRICE_ORACLE_SENTINEL_CHECK_FAILED = '105';
  string public constant RC_INVALID_DEBT_CEILING = '106';
  string public constant VL_INVALID_ISOLATION_MODE_BORROW_CATEGORY = '107';
  string public constant VL_DEBT_CEILING_CROSSED = '108';
  string public constant SL_USER_IN_ISOLATION_MODE = '109';
  string public constant PC_BRIDGE_PROTOCOL_FEE_INVALID = '110';
}




pragma solidity 0.8.7;













contract AaveOracle is IPriceOracleGetter {
  




  event BaseCurrencySet(address indexed baseCurrency, uint256 baseCurrencyUnit);

  




  event AssetSourceUpdated(address indexed asset, address indexed source);

  



  event FallbackOracleUpdated(address indexed fallbackOracle);

  IPoolAddressesProvider internal _addressesProvider;
  mapping(address => IChainlinkAggregator) private assetsSources;
  IPriceOracleGetter private _fallbackOracle;
  address public immutable override BASE_CURRENCY;
  uint256 public immutable override BASE_CURRENCY_UNIT;

  modifier onlyAssetListingOrPoolAdmins() {
    _onlyAssetListingOrPoolAdmins();
    _;
  }

  









  constructor(
    IPoolAddressesProvider provider,
    address[] memory assets,
    address[] memory sources,
    address fallbackOracle,
    address baseCurrency,
    uint256 baseCurrencyUnit
  ) {
    _addressesProvider = provider;
    _setFallbackOracle(fallbackOracle);
    _setAssetsSources(assets, sources);
    BASE_CURRENCY = baseCurrency;
    BASE_CURRENCY_UNIT = baseCurrencyUnit;
    emit BaseCurrencySet(baseCurrency, baseCurrencyUnit);
  }

  




  function setAssetSources(address[] calldata assets, address[] calldata sources)
    external
    onlyAssetListingOrPoolAdmins
  {
    _setAssetsSources(assets, sources);
  }

  




  function setFallbackOracle(address fallbackOracle) external onlyAssetListingOrPoolAdmins {
    _setFallbackOracle(fallbackOracle);
  }

  




  function _setAssetsSources(address[] memory assets, address[] memory sources) internal {
    require(assets.length == sources.length, 'INCONSISTENT_PARAMS_LENGTH');
    for (uint256 i = 0; i < assets.length; i++) {
      assetsSources[assets[i]] = IChainlinkAggregator(sources[i]);
      emit AssetSourceUpdated(assets[i], sources[i]);
    }
  }

  



  function _setFallbackOracle(address fallbackOracle) internal {
    _fallbackOracle = IPriceOracleGetter(fallbackOracle);
    emit FallbackOracleUpdated(fallbackOracle);
  }

  
  function getAssetPrice(address asset) public view override returns (uint256) {
    IChainlinkAggregator source = assetsSources[asset];

    if (asset == BASE_CURRENCY) {
      return BASE_CURRENCY_UNIT;
    } else if (address(source) == address(0)) {
      return _fallbackOracle.getAssetPrice(asset);
    } else {
      int256 price = IChainlinkAggregator(source).latestAnswer();
      if (price > 0) {
        return uint256(price);
      } else {
        return _fallbackOracle.getAssetPrice(asset);
      }
    }
  }

  




  function getAssetsPrices(address[] calldata assets) external view returns (uint256[] memory) {
    uint256[] memory prices = new uint256[](assets.length);
    for (uint256 i = 0; i < assets.length; i++) {
      prices[i] = getAssetPrice(assets[i]);
    }
    return prices;
  }

  




  function getSourceOfAsset(address asset) external view returns (address) {
    return address(assetsSources[asset]);
  }

  



  function getFallbackOracle() external view returns (address) {
    return address(_fallbackOracle);
  }

  function _onlyAssetListingOrPoolAdmins() internal view {
    IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
    require(
      aclManager.isAssetListingAdmin(msg.sender) || aclManager.isPoolAdmin(msg.sender),
      Errors.PC_CALLER_NOT_ASSET_LISTING_OR_POOL_ADMIN
    );
  }
}