


pragma solidity 0.8.7;




interface IERC20 {
  


  function totalSupply() external view returns (uint256);

  


  function balanceOf(address account) external view returns (uint256);

  






  function transfer(address recipient, uint256 amount) external returns (bool);

  






  function allowance(address owner, address spender) external view returns (uint256);

  













  function approve(address spender, uint256 amount) external returns (bool);

  








  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external returns (bool);

  





  event Transfer(address indexed from, address indexed to, uint256 value);

  



  event Approval(address indexed owner, address indexed spender, uint256 value);
}




pragma solidity 0.8.7;













abstract contract VersionedInitializable {
  


  uint256 private lastInitializedRevision = 0;

  


  bool private initializing;

  


  modifier initializer() {
    uint256 revision = getRevision();
    require(
      initializing || isConstructor() || revision > lastInitializedRevision,
      'Contract instance has already been initialized'
    );

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

  




  function getRevision() internal pure virtual returns (uint256);

  



  function isConstructor() private view returns (bool) {
    
    
    
    
    
    uint256 cs;
    
    assembly {
      cs := extcodesize(address())
    }
    return cs == 0;
  }

  
  uint256[50] private ______gap;
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







library WadRayMath {
  uint256 internal constant WAD = 1e18;
  uint256 internal constant HALF_WAD = WAD / 2;

  uint256 public constant RAY = 1e27;
  uint256 internal constant HALF_RAY = RAY / 2;

  uint256 internal constant WAD_RAY_RATIO = 1e9;

  



  function wad() internal pure returns (uint256) {
    return WAD;
  }

  


  function halfRay() internal pure returns (uint256) {
    return HALF_RAY;
  }

  


  function halfWad() internal pure returns (uint256) {
    return HALF_WAD;
  }

  





  function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      if (a == 0 || b == 0) {
        return 0;
      }

      require(a <= (type(uint256).max - HALF_WAD) / b, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * b + HALF_WAD) / WAD;
    }
  }

  





  function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      uint256 halfB = b / 2;

      require(a <= (type(uint256).max - halfB) / WAD, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * WAD + halfB) / b;
    }
  }

  





  function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      if (a == 0 || b == 0) {
        return 0;
      }

      require(a <= (type(uint256).max - HALF_RAY) / b, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * b + HALF_RAY) / RAY;
    }
  }

  





  function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    unchecked {
      uint256 halfB = b / 2;

      require(a <= (type(uint256).max - halfB) / RAY, Errors.MATH_MULTIPLICATION_OVERFLOW);

      return (a * RAY + halfB) / b;
    }
  }

  




  function rayToWad(uint256 a) internal pure returns (uint256) {
    unchecked {
      uint256 halfRatio = WAD_RAY_RATIO / 2;
      uint256 result = halfRatio + a;
      require(result >= halfRatio, Errors.MATH_ADDITION_OVERFLOW);

      return result / WAD_RAY_RATIO;
    }
  }

  




  function wadToRay(uint256 a) internal pure returns (uint256 result) {
    unchecked {
      require(
        (result = a * WAD_RAY_RATIO) / WAD_RAY_RATIO == a,
        Errors.MATH_MULTIPLICATION_OVERFLOW
      );
    }
  }
}




pragma solidity 0.8.7;






library MathUtils {
  using WadRayMath for uint256;

  
  uint256 internal constant SECONDS_PER_YEAR = 365 days;

  





  function calculateLinearInterest(uint256 rate, uint40 lastUpdateTimestamp)
    internal
    view
    returns (uint256)
  {
    
    uint256 result = rate * (block.timestamp - uint256(lastUpdateTimestamp));
    unchecked {
      result = result / SECONDS_PER_YEAR;
    }

    return WadRayMath.RAY + result;
  }

  












  function calculateCompoundedInterest(
    uint256 rate,
    uint40 lastUpdateTimestamp,
    uint256 currentTimestamp
  ) internal pure returns (uint256) {
    
    uint256 exp = currentTimestamp - uint256(lastUpdateTimestamp);

    if (exp == 0) {
      return WadRayMath.RAY;
    }

    uint256 expMinusOne;
    uint256 expMinusTwo;
    uint256 basePowerTwo;
    uint256 basePowerThree;
    unchecked {
      expMinusOne = exp - 1;

      expMinusTwo = exp > 2 ? exp - 2 : 0;

      basePowerTwo = rate.rayMul(rate) / (SECONDS_PER_YEAR * SECONDS_PER_YEAR);
      basePowerThree = basePowerTwo.rayMul(rate) / SECONDS_PER_YEAR;
    }

    uint256 secondTerm = exp * expMinusOne * basePowerTwo;
    unchecked {
      secondTerm /= 2;
    }
    uint256 thirdTerm = exp * expMinusOne * expMinusTwo * basePowerThree;
    unchecked {
      thirdTerm /= 6;
    }

    return WadRayMath.RAY + (rate * exp) / SECONDS_PER_YEAR + secondTerm + thirdTerm;
  }

  





  function calculateCompoundedInterest(uint256 rate, uint40 lastUpdateTimestamp)
    internal
    view
    returns (uint256)
  {
    return calculateCompoundedInterest(rate, lastUpdateTimestamp, block.timestamp);
  }
}




pragma solidity 0.8.7;

library DataTypes {
  
  struct ReserveData {
    
    ReserveConfigurationMap configuration;
    
    uint128 liquidityIndex;
    
    uint128 currentLiquidityRate;
    
    uint128 variableBorrowIndex;
    
    uint128 currentVariableBorrowRate;
    
    uint128 currentStableBorrowRate;
    uint40 lastUpdateTimestamp;
    
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    
    address interestRateStrategyAddress;
    
    uint8 id;
    
    uint128 accruedToTreasury;
    
    uint128 unbacked;
    uint128 isolationModeTotalDebt;
  }

  struct ReserveConfigurationMap {
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    uint256 data;
  }

  struct UserConfigurationMap {
    uint256 data;
  }

  struct EModeCategory {
    
    uint16 ltv;
    uint16 liquidationThreshold;
    uint16 liquidationBonus;
    
    address priceSource;
    string label;
  }

  enum InterestRateMode {
    NONE,
    STABLE,
    VARIABLE
  }

  struct ReserveCache {
    uint256 currScaledVariableDebt;
    uint256 nextScaledVariableDebt;
    uint256 currPrincipalStableDebt;
    uint256 currAvgStableBorrowRate;
    uint256 currTotalStableDebt;
    uint256 nextAvgStableBorrowRate;
    uint256 nextTotalStableDebt;
    uint256 currLiquidityIndex;
    uint256 nextLiquidityIndex;
    uint256 currVariableBorrowIndex;
    uint256 nextVariableBorrowIndex;
    uint256 currLiquidityRate;
    uint256 currVariableBorrowRate;
    uint256 reserveFactor;
    DataTypes.ReserveConfigurationMap reserveConfiguration;
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    uint40 reserveLastUpdateTimestamp;
    uint40 stableDebtLastUpdateTimestamp;
  }

  struct ExecuteLiquidationCallParams {
    uint256 reservesCount;
    uint256 debtToCover;
    address collateralAsset;
    address debtAsset;
    address user;
    bool receiveAToken;
    address priceOracle;
    uint8 userEModeCategory;
    address priceOracleSentinel;
  }

  struct ExecuteSupplyParams {
    address asset;
    uint256 amount;
    address onBehalfOf;
    uint16 referralCode;
  }

  struct ExecuteBorrowParams {
    address asset;
    address user;
    address onBehalfOf;
    uint256 amount;
    uint256 interestRateMode;
    uint16 referralCode;
    bool releaseUnderlying;
    uint256 maxStableRateBorrowSizePercent;
    uint256 reservesCount;
    address oracle;
    uint8 userEModeCategory;
    address priceOracleSentinel;
  }

  struct ExecuteRepayParams {
    address asset;
    uint256 amount;
    uint256 rateMode;
    address onBehalfOf;
    bool useATokens;
  }

  struct ExecuteWithdrawParams {
    address asset;
    uint256 amount;
    address to;
    uint256 reservesCount;
    address oracle;
    uint8 userEModeCategory;
  }

  struct ExecuteSetUserEModeParams {
    uint256 reservesCount;
    address oracle;
    uint8 categoryId;
  }

  struct FinalizeTransferParams {
    address asset;
    address from;
    address to;
    uint256 amount;
    uint256 balanceFromBefore;
    uint256 balanceToBefore;
    uint256 reservesCount;
    address oracle;
    uint8 fromEModeCategory;
    uint8 toEModeCategory;
  }

  struct FlashloanParams {
    address receiverAddress;
    address[] assets;
    uint256[] amounts;
    uint256[] modes;
    address onBehalfOf;
    bytes params;
    uint16 referralCode;
    uint256 flashLoanPremiumToProtocol;
    uint256 flashLoanPremiumTotal;
    uint256 maxStableRateBorrowSizePercent;
    uint256 reservesCount;
    address addressesProvider;
    uint8 userEModeCategory;
    bool isAuthorizedFlashBorrower;
  }

  struct FlashloanSimpleParams {
    address receiverAddress;
    address asset;
    uint256 amount;
    bytes params;
    uint16 referralCode;
    uint256 flashLoanPremiumToProtocol;
    uint256 flashLoanPremiumTotal;
  }

  struct CalculateUserAccountDataParams {
    UserConfigurationMap userConfig;
    uint256 reservesCount;
    address user;
    address oracle;
    uint8 userEModeCategory;
  }

  struct ValidateBorrowParams {
    DataTypes.ReserveCache reserveCache;
    DataTypes.UserConfigurationMap userConfig;
    address asset;
    address userAddress;
    uint256 amount;
    uint256 interestRateMode;
    uint256 maxStableLoanPercent;
    uint256 reservesCount;
    address oracle;
    uint8 userEModeCategory;
    address priceOracleSentinel;
    bool isolationModeActive;
    address isolationModeCollateralAddress;
    uint256 isolationModeDebtCeiling;
  }

  struct ValidateLiquidationCallParams {
    DataTypes.ReserveCache debtReserveCache;
    uint256 totalDebt;
    uint256 healthFactor;
    address priceOracleSentinel;
  }

  struct CalculateInterestRatesParams {
    uint256 unbacked;
    uint256 liquidityAdded;
    uint256 liquidityTaken;
    uint256 totalStableDebt;
    uint256 totalVariableDebt;
    uint256 averageStableBorrowRate;
    uint256 reserveFactor;
    address reserve;
    address aToken;
  }
}




pragma solidity 0.8.7;







library Helpers {
  






  function getUserCurrentDebt(address user, DataTypes.ReserveData storage reserve)
    internal
    view
    returns (uint256, uint256)
  {
    return (
      IERC20(reserve.stableDebtTokenAddress).balanceOf(user),
      IERC20(reserve.variableDebtTokenAddress).balanceOf(user)
    );
  }

  






  function getUserCurrentDebtMemory(address user, DataTypes.ReserveData memory reserve)
    internal
    view
    returns (uint256, uint256)
  {
    return (
      IERC20(reserve.stableDebtTokenAddress).balanceOf(user),
      IERC20(reserve.variableDebtTokenAddress).balanceOf(user)
    );
  }

  function castUint128(uint256 input) internal pure returns (uint128) {
    require(input <= type(uint128).max, Errors.HLP_UINT128_OVERFLOW);
    return uint128(input);
  }
}




pragma solidity 0.8.7;






interface IAaveIncentivesController {
  




  event RewardsAccrued(address indexed user, uint256 amount);

  event RewardsClaimed(address indexed user, address indexed to, uint256 amount);

  






  event RewardsClaimed(
    address indexed user,
    address indexed to,
    address indexed claimer,
    uint256 amount
  );

  




  event ClaimerSet(address indexed user, address indexed claimer);

  






  function getAssetData(address asset)
    external
    view
    returns (
      uint256,
      uint256,
      uint256
    );

  




  function setClaimer(address user, address claimer) external;

  




  function getClaimer(address user) external view returns (address);

  




  function configureAssets(address[] calldata assets, uint256[] calldata emissionsPerSecond)
    external;

  





  function handleAction(
    address asset,
    uint256 userBalance,
    uint256 totalSupply
  ) external;

  





  function getRewardsBalance(address[] calldata assets, address user)
    external
    view
    returns (uint256);

  






  function claimRewards(
    address[] calldata assets,
    uint256 amount,
    address to
  ) external returns (uint256);

  








  function claimRewardsOnBehalf(
    address[] calldata assets,
    uint256 amount,
    address user,
    address to
  ) external returns (uint256);

  




  function getUserUnclaimedRewards(address user) external view returns (uint256);

  





  function getUserAssetData(address user, address asset) external view returns (uint256);

  



  function REWARD_TOKEN() external view returns (address);

  



  function PRECISION() external view returns (uint8);
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







interface IPool {
  







  event MintUnbacked(
    address indexed reserve,
    address user,
    address indexed onBehalfOf,
    uint256 amount,
    uint16 indexed referral
  );

  





  event BackUnbacked(address indexed reserve, address indexed backer, uint256 amount, uint256 fee);

  







  event Supply(
    address indexed reserve,
    address user,
    address indexed onBehalfOf,
    uint256 amount,
    uint16 indexed referralCode
  );

  






  event Withdraw(address indexed reserve, address indexed user, address indexed to, uint256 amount);

  










  event Borrow(
    address indexed reserve,
    address user,
    address indexed onBehalfOf,
    uint256 amount,
    uint256 borrowRateMode,
    uint256 borrowRate,
    uint16 indexed referral
  );

  






  event Repay(
    address indexed reserve,
    address indexed user,
    address indexed repayer,
    uint256 amount
  );

  





  event Swap(address indexed reserve, address indexed user, uint256 rateMode);

  




  event ReserveUsedAsCollateralEnabled(address indexed reserve, address indexed user);

  




  event ReserveUsedAsCollateralDisabled(address indexed reserve, address indexed user);

  




  event RebalanceStableBorrowRate(address indexed reserve, address indexed user);

  








  event FlashLoan(
    address indexed target,
    address indexed initiator,
    address indexed asset,
    uint256 amount,
    uint256 premium,
    uint16 referralCode
  );

  










  event LiquidationCall(
    address indexed collateralAsset,
    address indexed debtAsset,
    address indexed user,
    uint256 debtToCover,
    uint256 liquidatedCollateralAmount,
    address liquidator,
    bool receiveAToken
  );

  








  event ReserveDataUpdated(
    address indexed reserve,
    uint256 liquidityRate,
    uint256 stableBorrowRate,
    uint256 variableBorrowRate,
    uint256 liquidityIndex,
    uint256 variableBorrowIndex
  );

  




  event MintedToTreasury(address indexed reserve, uint256 amountMinted);

  







  function mintUnbacked(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external;

  





  function backUnbacked(
    address asset,
    uint256 amount,
    uint256 fee
  ) external;

  




  event UserEModeSet(address indexed user, uint8 categoryId);

  










  function supply(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external;

  














  function supplyWithPermit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode,
    uint256 deadline,
    uint8 permitV,
    bytes32 permitR,
    bytes32 permitS
  ) external;

  










  function withdraw(
    address asset,
    uint256 amount,
    address to
  ) external returns (uint256);

  














  function borrow(
    address asset,
    uint256 amount,
    uint256 interestRateMode,
    uint16 referralCode,
    address onBehalfOf
  ) external;

  











  function repay(
    address asset,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external returns (uint256);

  















  function repayWithPermit(
    address asset,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf,
    uint256 deadline,
    uint8 permitV,
    bytes32 permitR,
    bytes32 permitS
  ) external returns (uint256);

  











  function repayWithATokens(
    address asset,
    uint256 amount,
    uint256 rateMode,
    address onBehalfOf
  ) external returns (uint256);

  




  function swapBorrowRateMode(address asset, uint256 rateMode) external;

  








  function rebalanceStableBorrowRate(address asset, address user) external;

  




  function setUserUseReserveAsCollateral(address asset, bool useAsCollateral) external;

  










  function liquidationCall(
    address collateralAsset,
    address debtAsset,
    address user,
    uint256 debtToCover,
    bool receiveAToken
  ) external;

  
















  function flashLoan(
    address receiverAddress,
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata modes,
    address onBehalfOf,
    bytes calldata params,
    uint16 referralCode
  ) external;

  











  function flashLoanSimple(
    address receiverAddress,
    address asset,
    uint256 amount,
    bytes calldata params,
    uint16 referralCode
  ) external;

  









  function getUserAccountData(address user)
    external
    view
    returns (
      uint256 totalCollateralBase,
      uint256 totalDebtBase,
      uint256 availableBorrowsBase,
      uint256 currentLiquidationThreshold,
      uint256 ltv,
      uint256 healthFactor
    );

  









  function initReserve(
    address asset,
    address aTokenAddress,
    address stableDebtAddress,
    address variableDebtAddress,
    address interestRateStrategyAddress
  ) external;

  




  function dropReserve(address asset) external;

  





  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
    external;

  





  function setConfiguration(address asset, uint256 configuration) external;

  




  function getConfiguration(address asset)
    external
    view
    returns (DataTypes.ReserveConfigurationMap memory);

  




  function getUserConfiguration(address user)
    external
    view
    returns (DataTypes.UserConfigurationMap memory);

  




  function getReserveNormalizedIncome(address asset) external view returns (uint256);

  




  function getReserveNormalizedVariableDebt(address asset) external view returns (uint256);

  




  function getReserveData(address asset) external view returns (DataTypes.ReserveData memory);

  









  function finalizeTransfer(
    address asset,
    address from,
    address to,
    uint256 amount,
    uint256 balanceFromBefore,
    uint256 balanceToBefore
  ) external;

  




  function getReservesList() external view returns (address[] memory);

  



  function getAddressesProvider() external view returns (IPoolAddressesProvider);

  



  function updateBridgeProtocolFee(uint256 bridgeProtocolFee) external;

  







  function updateFlashloanPremiums(
    uint256 flashLoanPremiumTotal,
    uint256 flashLoanPremiumToProtocol
  ) external;

  






  function configureEModeCategory(uint8 id, DataTypes.EModeCategory memory config) external;

  




  function getEModeCategoryData(uint8 id) external returns (DataTypes.EModeCategory memory);

  



  function setUserEMode(uint8 categoryId) external;

  




  function getUserEMode(address user) external view returns (uint256);

  



  function MAX_STABLE_RATE_BORROW_SIZE_PERCENT() external view returns (uint256);

  



  function FLASHLOAN_PREMIUM_TOTAL() external view returns (uint256);

  



  function BRIDGE_PROTOCOL_FEE() external view returns (uint256);

  



  function FLASHLOAN_PREMIUM_TO_PROTOCOL() external view returns (uint256);

  



  function MAX_NUMBER_RESERVES() external view returns (uint256);

  



  function mintToTreasury(address[] calldata assets) external;

  











  function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external;
}




pragma solidity 0.8.7;







interface IInitializableDebtToken {
  









  event Initialized(
    address indexed underlyingAsset,
    address indexed pool,
    address incentivesController,
    uint8 debtTokenDecimals,
    string debtTokenName,
    string debtTokenSymbol,
    bytes params
  );

  








  function initialize(
    address underlyingAsset,
    IAaveIncentivesController incentivesController,
    uint8 debtTokenDecimals,
    string memory debtTokenName,
    string memory debtTokenSymbol,
    bytes calldata params
  ) external;
}




pragma solidity 0.8.7;








interface IStableDebtToken is IInitializableDebtToken {
  










  event Mint(
    address indexed user,
    address indexed onBehalfOf,
    uint256 amount,
    uint256 currentBalance,
    uint256 balanceIncrease,
    uint256 newRate,
    uint256 avgStableRate,
    uint256 newTotalSupply
  );

  








  event Burn(
    address indexed user,
    uint256 amount,
    uint256 currentBalance,
    uint256 balanceIncrease,
    uint256 avgStableRate,
    uint256 newTotalSupply
  );

  












  function mint(
    address user,
    address onBehalfOf,
    uint256 amount,
    uint256 rate
  )
    external
    returns (
      bool,
      uint256,
      uint256
    );

  








  function burn(address user, uint256 amount) external returns (uint256, uint256);

  



  function getAverageStableRate() external view returns (uint256);

  




  function getUserStableRate(address user) external view returns (uint256);

  




  function getUserLastUpdated(address user) external view returns (uint40);

  






  function getSupplyData()
    external
    view
    returns (
      uint256,
      uint256,
      uint256,
      uint40
    );

  



  function getTotalSupplyLastUpdated() external view returns (uint40);

  




  function getTotalSupplyAndAvgRate() external view returns (uint256, uint256);

  



  function principalBalanceOf(address user) external view returns (uint256);
}




pragma solidity 0.8.7;






interface ICreditDelegationToken {
  






  event BorrowAllowanceDelegated(
    address indexed fromUser,
    address indexed toUser,
    address asset,
    uint256 amount
  );

  






  function approveDelegation(address delegatee, uint256 amount) external;

  





  function borrowAllowance(address fromUser, address toUser) external view returns (uint256);
}




pragma solidity 0.8.7;











abstract contract Context {
  function _msgSender() internal view virtual returns (address payable) {
    return payable(msg.sender);
  }

  function _msgData() internal view virtual returns (bytes memory) {
    this; 
    return msg.data;
  }
}




pragma solidity 0.8.7;

interface IERC20Detailed is IERC20 {
  function name() external view returns (string memory);

  function symbol() external view returns (string memory);

  function decimals() external view returns (uint8);
}




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














abstract contract IncentivizedERC20 is Context, IERC20, IERC20Detailed {
  using WadRayMath for uint256;

  modifier onlyPoolAdmin() {
    IACLManager aclManager = IACLManager(_addressesProvider.getACLManager());
    require(aclManager.isPoolAdmin(msg.sender), Errors.CALLER_NOT_POOL_ADMIN);
    _;
  }

  





  struct UserState {
    uint128 balance;
    uint128 additionalData;
  }
  mapping(address => UserState) internal _userState;

  mapping(address => mapping(address => uint256)) private _allowances;
  uint256 internal _totalSupply;
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  IAaveIncentivesController internal _incentivesController;
  IPoolAddressesProvider internal _addressesProvider;

  constructor(
    IPoolAddressesProvider addressesProvider,
    string memory name,
    string memory symbol,
    uint8 decimals
  ) {
    _addressesProvider = addressesProvider;
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  
  function name() external view override returns (string memory) {
    return _name;
  }

  
  function symbol() external view override returns (string memory) {
    return _symbol;
  }

  
  function decimals() external view override returns (uint8) {
    return _decimals;
  }

  
  function totalSupply() public view virtual override returns (uint256) {
    return _totalSupply;
  }

  
  function balanceOf(address account) public view virtual override returns (uint256) {
    return _userState[account].balance;
  }

  



  function getIncentivesController() external view virtual returns (IAaveIncentivesController) {
    return _incentivesController;
  }

  



  function setIncentivesController(IAaveIncentivesController controller) external onlyPoolAdmin {
    _incentivesController = controller;
  }

  
  function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
    uint128 castAmount = Helpers.castUint128(amount);
    _transfer(_msgSender(), recipient, castAmount);
    return true;
  }

  
  function allowance(address owner, address spender)
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _allowances[owner][spender];
  }

  
  function approve(address spender, uint256 amount) external virtual override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }

  
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external virtual override returns (bool) {
    uint128 castAmount = Helpers.castUint128(amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - castAmount);
    _transfer(sender, recipient, castAmount);
    return true;
  }

  





  function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
    return true;
  }

  





  function decreaseAllowance(address spender, uint256 subtractedValue)
    external
    virtual
    returns (bool)
  {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
    return true;
  }

  function _transfer(
    address sender,
    address recipient,
    uint128 amount
  ) internal virtual {
    uint128 oldSenderBalance = _userState[sender].balance;
    _userState[sender].balance = oldSenderBalance - amount;
    uint128 oldRecipientBalance = _userState[recipient].balance;
    _userState[recipient].balance = oldRecipientBalance + amount;

    IAaveIncentivesController incentivesControllerLocal = _incentivesController;
    if (address(incentivesControllerLocal) != address(0)) {
      uint256 currentTotalSupply = _totalSupply;
      incentivesControllerLocal.handleAction(sender, currentTotalSupply, oldSenderBalance);
      if (sender != recipient) {
        incentivesControllerLocal.handleAction(recipient, currentTotalSupply, oldRecipientBalance);
      }
    }
    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account, uint128 amount) internal virtual {
    uint256 oldTotalSupply = _totalSupply;
    _totalSupply = oldTotalSupply + amount;

    uint128 oldAccountBalance = _userState[account].balance;
    _userState[account].balance = oldAccountBalance + amount;

    IAaveIncentivesController incentivesControllerLocal = _incentivesController;
    if (address(incentivesControllerLocal) != address(0)) {
      incentivesControllerLocal.handleAction(account, oldTotalSupply, oldAccountBalance);
    }
  }

  function _burn(address account, uint128 amount) internal virtual {
    uint256 oldTotalSupply = _totalSupply;
    _totalSupply = oldTotalSupply - amount;

    uint128 oldAccountBalance = _userState[account].balance;
    _userState[account].balance = oldAccountBalance - amount;

    IAaveIncentivesController incentivesControllerLocal = _incentivesController;

    if (address(incentivesControllerLocal) != address(0)) {
      incentivesControllerLocal.handleAction(account, oldTotalSupply, oldAccountBalance);
    }
  }

  function _approve(
    address owner,
    address spender,
    uint256 amount
  ) internal virtual {
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  function _setName(string memory newName) internal {
    _name = newName;
  }

  function _setSymbol(string memory newSymbol) internal {
    _symbol = newSymbol;
  }

  function _setDecimals(uint8 newDecimals) internal {
    _decimals = newDecimals;
  }
}




pragma solidity 0.8.7;











abstract contract DebtTokenBase is
  IncentivizedERC20,
  VersionedInitializable,
  ICreditDelegationToken
{
  mapping(address => mapping(address => uint256)) internal _borrowAllowances;
  bytes public constant EIP712_REVISION = bytes('1');
  bytes32 internal constant EIP712_DOMAIN =
    keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)');
  bytes32 public constant DELEGATION_WITH_SIG_TYPEHASH =
    keccak256(
      'DelegationWithSig(address delegator,address delegatee,uint256 value,uint256 nonce,uint256 deadline)'
    );
  mapping(address => uint256) public _nonces;
  bytes32 public DOMAIN_SEPARATOR;
  IPool internal immutable _pool;

  


  modifier onlyPool() {
    require(_msgSender() == address(_pool), Errors.CT_CALLER_MUST_BE_POOL);
    _;
  }

  constructor(IPool pool)
    IncentivizedERC20(pool.getAddressesProvider(), 'DEBT_TOKEN_IMPL', 'DEBT_TOKEN_IMPL', 0)
  {
    _pool = pool;
  }

  
  function approveDelegation(address delegatee, uint256 amount) external override {
    _approveDelegation(_msgSender(), delegatee, amount);
  }

  









  function delegationWithSig(
    address delegator,
    address delegatee,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external {
    require(delegator != address(0), 'INVALID_DELEGATOR');
    
    require(block.timestamp <= deadline, 'INVALID_EXPIRATION');
    uint256 currentValidNonce = _nonces[delegator];
    bytes32 digest = keccak256(
      abi.encodePacked(
        '\x19\x01',
        DOMAIN_SEPARATOR,
        keccak256(
          abi.encode(
            DELEGATION_WITH_SIG_TYPEHASH,
            delegator,
            delegatee,
            value,
            currentValidNonce,
            deadline
          )
        )
      )
    );
    require(delegator == ecrecover(digest, v, r, s), 'INVALID_SIGNATURE');
    _nonces[delegator] = currentValidNonce + 1;
    _approveDelegation(delegator, delegatee, value);
  }

  
  function borrowAllowance(address fromUser, address toUser)
    external
    view
    override
    returns (uint256)
  {
    return _borrowAllowances[fromUser][toUser];
  }

  




  function _getUnderlyingAssetAddress() internal view virtual returns (address);

  



  function POOL() external view returns (IPool) {
    return _pool;
  }

  



  function transfer(address, uint256) external virtual override returns (bool) {
    revert('TRANSFER_NOT_SUPPORTED');
  }

  function allowance(address, address) external view virtual override returns (uint256) {
    revert('ALLOWANCE_NOT_SUPPORTED');
  }

  function approve(address, uint256) external virtual override returns (bool) {
    revert('APPROVAL_NOT_SUPPORTED');
  }

  function transferFrom(
    address,
    address,
    uint256
  ) external virtual override returns (bool) {
    revert('TRANSFER_NOT_SUPPORTED');
  }

  function increaseAllowance(address, uint256) external virtual override returns (bool) {
    revert('ALLOWANCE_NOT_SUPPORTED');
  }

  function decreaseAllowance(address, uint256) external virtual override returns (bool) {
    revert('ALLOWANCE_NOT_SUPPORTED');
  }

  function _approveDelegation(
    address delegator,
    address delegatee,
    uint256 amount
  ) internal {
    _borrowAllowances[delegator][delegatee] = amount;
    emit BorrowAllowanceDelegated(delegator, delegatee, _getUnderlyingAssetAddress(), amount);
  }

  function _decreaseBorrowAllowance(
    address delegator,
    address delegatee,
    uint256 amount
  ) internal {
    uint256 newAllowance = _borrowAllowances[delegator][delegatee] - amount;

    _borrowAllowances[delegator][delegatee] = newAllowance;

    emit BorrowAllowanceDelegated(delegator, delegatee, _getUnderlyingAssetAddress(), newAllowance);
  }
}




pragma solidity 0.8.7;


















contract StableDebtToken is IStableDebtToken, DebtTokenBase {
  using WadRayMath for uint256;

  uint256 public constant DEBT_TOKEN_REVISION = 0x2;

  uint256 internal _avgStableRate;
  mapping(address => uint40) internal _timestamps;
  uint40 internal _totalSupplyTimestamp;

  address internal _underlyingAsset;

  constructor(IPool pool) DebtTokenBase(pool) {}

  
  function initialize(
    address underlyingAsset,
    IAaveIncentivesController incentivesController,
    uint8 debtTokenDecimals,
    string memory debtTokenName,
    string memory debtTokenSymbol,
    bytes calldata params
  ) external override initializer {
    uint256 chainId = block.chainid;

    _setName(debtTokenName);
    _setSymbol(debtTokenSymbol);
    _setDecimals(debtTokenDecimals);

    _underlyingAsset = underlyingAsset;
    _incentivesController = incentivesController;

    DOMAIN_SEPARATOR = keccak256(
      abi.encode(
        EIP712_DOMAIN,
        keccak256(bytes(debtTokenName)),
        keccak256(EIP712_REVISION),
        chainId,
        address(this)
      )
    );

    emit Initialized(
      underlyingAsset,
      address(_pool),
      address(incentivesController),
      debtTokenDecimals,
      debtTokenName,
      debtTokenSymbol,
      params
    );
  }

  
  function getRevision() internal pure virtual override returns (uint256) {
    return DEBT_TOKEN_REVISION;
  }

  
  function getAverageStableRate() external view virtual override returns (uint256) {
    return _avgStableRate;
  }

  
  function getUserLastUpdated(address user) external view virtual override returns (uint40) {
    return _timestamps[user];
  }

  
  function getUserStableRate(address user) external view virtual override returns (uint256) {
    return _userState[user].additionalData;
  }

  
  function balanceOf(address account) public view virtual override returns (uint256) {
    uint256 accountBalance = super.balanceOf(account);
    uint256 stableRate = _userState[account].additionalData;
    if (accountBalance == 0) {
      return 0;
    }
    uint256 cumulatedInterest = MathUtils.calculateCompoundedInterest(
      stableRate,
      _timestamps[account]
    );
    return accountBalance.rayMul(cumulatedInterest);
  }

  struct MintLocalVars {
    uint256 previousSupply;
    uint256 nextSupply;
    uint256 amountInRay;
    uint256 currentStableRate;
    uint256 nextStableRate;
    uint256 currentAvgStableRate;
  }

  
  function mint(
    address user,
    address onBehalfOf,
    uint256 amount,
    uint256 rate
  )
    external
    override
    onlyPool
    returns (
      bool,
      uint256,
      uint256
    )
  {
    MintLocalVars memory vars;

    if (user != onBehalfOf) {
      _decreaseBorrowAllowance(onBehalfOf, user, amount);
    }

    (, uint256 currentBalance, uint256 balanceIncrease) = _calculateBalanceIncrease(onBehalfOf);

    vars.previousSupply = totalSupply();
    vars.currentAvgStableRate = _avgStableRate;
    vars.nextSupply = _totalSupply = vars.previousSupply + amount;

    vars.amountInRay = amount.wadToRay();

    vars.currentStableRate = _userState[onBehalfOf].additionalData;
    vars.nextStableRate = (vars.currentStableRate.rayMul(currentBalance.wadToRay()) +
      vars.amountInRay.rayMul(rate)).rayDiv((currentBalance + amount).wadToRay());

    _userState[onBehalfOf].additionalData = Helpers.castUint128(vars.nextStableRate);

    
    _totalSupplyTimestamp = _timestamps[onBehalfOf] = uint40(block.timestamp);

    
    vars.currentAvgStableRate = _avgStableRate = (vars.currentAvgStableRate.rayMul(
      vars.previousSupply.wadToRay()
    ) + rate.rayMul(vars.amountInRay)).rayDiv(vars.nextSupply.wadToRay());

    _mint(onBehalfOf, amount + balanceIncrease, vars.previousSupply);

    emit Transfer(address(0), onBehalfOf, amount + balanceIncrease);
    emit Mint(
      user,
      onBehalfOf,
      amount,
      currentBalance,
      balanceIncrease,
      vars.nextStableRate,
      vars.currentAvgStableRate,
      vars.nextSupply
    );

    return (currentBalance == 0, vars.nextSupply, vars.currentAvgStableRate);
  }

  
  function burn(address user, uint256 amount)
    external
    override
    onlyPool
    returns (uint256, uint256)
  {
    (, uint256 currentBalance, uint256 balanceIncrease) = _calculateBalanceIncrease(user);

    uint256 previousSupply = totalSupply();
    uint256 nextAvgStableRate = 0;
    uint256 nextSupply = 0;
    uint256 userStableRate = _userState[user].additionalData;

    
    
    
    
    if (previousSupply <= amount) {
      _avgStableRate = 0;
      _totalSupply = 0;
    } else {
      nextSupply = _totalSupply = previousSupply - amount;
      uint256 firstTerm = _avgStableRate.rayMul(previousSupply.wadToRay());
      uint256 secondTerm = userStableRate.rayMul(amount.wadToRay());

      
      
      
      if (secondTerm >= firstTerm) {
        nextAvgStableRate = _avgStableRate = _totalSupply = 0;
      } else {
        nextAvgStableRate = _avgStableRate = (firstTerm - secondTerm).rayDiv(nextSupply.wadToRay());
      }
    }

    if (amount == currentBalance) {
      _userState[user].additionalData = 0;
      _timestamps[user] = 0;
    } else {
      
      _timestamps[user] = uint40(block.timestamp);
    }
    
    _totalSupplyTimestamp = uint40(block.timestamp);

    if (balanceIncrease > amount) {
      uint256 amountToMint = balanceIncrease - amount;
      _mint(user, amountToMint, previousSupply);
      emit Transfer(address(0), user, balanceIncrease - amount);
      emit Mint(
        user,
        user,
        amountToMint,
        currentBalance,
        balanceIncrease,
        userStableRate,
        nextAvgStableRate,
        nextSupply
      );
    } else {
      uint256 amountToBurn = amount - balanceIncrease;
      _burn(user, amountToBurn, previousSupply);
      emit Transfer(address(0), user, amount - balanceIncrease);
      emit Burn(user, amountToBurn, currentBalance, balanceIncrease, nextAvgStableRate, nextSupply);
    }

    return (nextSupply, nextAvgStableRate);
  }

  






  function _calculateBalanceIncrease(address user)
    internal
    view
    returns (
      uint256,
      uint256,
      uint256
    )
  {
    uint256 previousPrincipalBalance = super.balanceOf(user);

    if (previousPrincipalBalance == 0) {
      return (0, 0, 0);
    }

    
    uint256 balanceIncrease = balanceOf(user) - previousPrincipalBalance;

    return (previousPrincipalBalance, previousPrincipalBalance + balanceIncrease, balanceIncrease);
  }

  
  function getSupplyData()
    external
    view
    override
    returns (
      uint256,
      uint256,
      uint256,
      uint40
    )
  {
    uint256 avgRate = _avgStableRate;
    return (super.totalSupply(), _calcTotalSupply(avgRate), avgRate, _totalSupplyTimestamp);
  }

  
  function getTotalSupplyAndAvgRate() external view override returns (uint256, uint256) {
    uint256 avgRate = _avgStableRate;
    return (_calcTotalSupply(avgRate), avgRate);
  }

  
  function totalSupply() public view override returns (uint256) {
    return _calcTotalSupply(_avgStableRate);
  }

  
  function getTotalSupplyLastUpdated() external view override returns (uint40) {
    return _totalSupplyTimestamp;
  }

  
  function principalBalanceOf(address user) external view virtual override returns (uint256) {
    return super.balanceOf(user);
  }

  



  function UNDERLYING_ASSET_ADDRESS() external view returns (address) {
    return _underlyingAsset;
  }

  
  function _getUnderlyingAssetAddress() internal view override returns (address) {
    return _underlyingAsset;
  }

  




  function _calcTotalSupply(uint256 avgRate) internal view virtual returns (uint256) {
    uint256 principalSupply = super.totalSupply();

    if (principalSupply == 0) {
      return 0;
    }

    uint256 cumulatedInterest = MathUtils.calculateCompoundedInterest(
      avgRate,
      _totalSupplyTimestamp
    );

    return principalSupply.rayMul(cumulatedInterest);
  }

  





  function _mint(
    address account,
    uint256 amount,
    uint256 oldTotalSupply
  ) internal {
    uint128 castAmount = Helpers.castUint128(amount);
    uint128 oldAccountBalance = _userState[account].balance;
    _userState[account].balance = oldAccountBalance + castAmount;

    if (address(_incentivesController) != address(0)) {
      _incentivesController.handleAction(account, oldTotalSupply, oldAccountBalance);
    }
  }

  





  function _burn(
    address account,
    uint256 amount,
    uint256 oldTotalSupply
  ) internal {
    uint128 castAmount = Helpers.castUint128(amount);
    uint128 oldAccountBalance = _userState[account].balance;
    _userState[account].balance = oldAccountBalance - castAmount;

    if (address(_incentivesController) != address(0)) {
      _incentivesController.handleAction(account, oldTotalSupply, oldAccountBalance);
    }
  }
}