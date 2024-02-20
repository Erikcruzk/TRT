


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






interface IScaledBalanceToken {
  





  function scaledBalanceOf(address user) external view returns (uint256);

  





  function getScaledUserBalanceAndSupply(address user) external view returns (uint256, uint256);

  



  function scaledTotalSupply() external view returns (uint256);

  




  function getPreviousIndex(address user) external view returns (uint256);
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







interface IInitializableAToken {
  










  event Initialized(
    address indexed underlyingAsset,
    address indexed pool,
    address treasury,
    address incentivesController,
    uint8 aTokenDecimals,
    string aTokenName,
    string aTokenSymbol,
    bytes params
  );

  









  function initialize(
    address treasury,
    address underlyingAsset,
    IAaveIncentivesController incentivesController,
    uint8 aTokenDecimals,
    string calldata aTokenName,
    string calldata aTokenSymbol,
    bytes calldata params
  ) external;
}




pragma solidity 0.8.7;









interface IAToken is IERC20, IScaledBalanceToken, IInitializableAToken {
  





  event Mint(address indexed from, uint256 value, uint256 index);

  






  function mint(
    address user,
    uint256 amount,
    uint256 index
  ) external returns (bool);

  






  event Burn(address indexed from, address indexed target, uint256 value, uint256 index);

  






  event BalanceTransfer(address indexed from, address indexed to, uint256 value, uint256 index);

  






  function burn(
    address user,
    address receiverOfUnderlying,
    uint256 amount,
    uint256 index
  ) external;

  




  function mintToTreasury(uint256 amount, uint256 index) external;

  





  function transferOnLiquidation(
    address from,
    address to,
    uint256 value
  ) external;

  





  function transferUnderlyingTo(address user, uint256 amount) external;

  




  function handleRepayment(address user, uint256 amount) external;

  











  function permit(
    address owner,
    address spender,
    uint256 value,
    uint256 deadline,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external;

  



  function UNDERLYING_ASSET_ADDRESS() external view returns (address);

  


  function RESERVE_TREASURY_ADDRESS() external view returns (address);
}