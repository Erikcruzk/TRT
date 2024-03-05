


pragma solidity 0.8.7;

library ConfiguratorInputTypes {
  struct InitReserveInput {
    address aTokenImpl;
    address stableDebtTokenImpl;
    address variableDebtTokenImpl;
    uint8 underlyingAssetDecimals;
    address interestRateStrategyAddress;
    address underlyingAsset;
    address treasury;
    address incentivesController;
    string underlyingAssetName;
    string aTokenName;
    string aTokenSymbol;
    string variableDebtTokenName;
    string variableDebtTokenSymbol;
    string stableDebtTokenName;
    string stableDebtTokenSymbol;
    bytes params;
  }

  struct UpdateATokenInput {
    address asset;
    address treasury;
    address incentivesController;
    string name;
    string symbol;
    address implementation;
    bytes params;
  }

  struct UpdateDebtTokenInput {
    address asset;
    address incentivesController;
    string name;
    string symbol;
    address implementation;
    bytes params;
  }
}




pragma solidity 0.8.7;






interface IPoolConfigurator {
  







  event ReserveInitialized(
    address indexed asset,
    address indexed aToken,
    address stableDebtToken,
    address variableDebtToken,
    address interestRateStrategyAddress
  );

  




  event BorrowingEnabledOnReserve(address indexed asset, bool stableRateEnabled);

  



  event BorrowingDisabledOnReserve(address indexed asset);

  






  event CollateralConfigurationChanged(
    address indexed asset,
    uint256 ltv,
    uint256 liquidationThreshold,
    uint256 liquidationBonus
  );

  



  event StableRateEnabledOnReserve(address indexed asset);

  



  event StableRateDisabledOnReserve(address indexed asset);

  



  event ReserveActivated(address indexed asset);

  



  event ReserveDeactivated(address indexed asset);

  



  event ReserveFrozen(address indexed asset);

  



  event ReserveUnfrozen(address indexed asset);

  



  event ReservePaused(address indexed asset);

  



  event ReserveUnpaused(address indexed asset);

  



  event ReserveDropped(address indexed asset);

  




  event ReserveFactorChanged(address indexed asset, uint256 factor);

  




  event BorrowCapChanged(address indexed asset, uint256 borrowCap);

  




  event SupplyCapChanged(address indexed asset, uint256 supplyCap);

  




  event LiquidationProtocolFeeChanged(address indexed asset, uint256 fee);

  




  event UnbackedMintCapChanged(address indexed asset, uint256 unbackedMintCap);
  




  event EModeAssetCategoryChanged(address indexed asset, uint8 categoryId);

  








  event EModeCategoryAdded(
    uint8 indexed categoryId,
    uint256 ltv,
    uint256 liquidationThreshold,
    uint256 liquidationBonus,
    address oracle,
    string label
  );

  




  event ReserveDecimalsChanged(address indexed asset, uint256 decimals);

  




  event ReserveInterestRateStrategyChanged(address indexed asset, address strategy);

  





  event ATokenUpgraded(
    address indexed asset,
    address indexed proxy,
    address indexed implementation
  );

  





  event StableDebtTokenUpgraded(
    address indexed asset,
    address indexed proxy,
    address indexed implementation
  );

  





  event VariableDebtTokenUpgraded(
    address indexed asset,
    address indexed proxy,
    address indexed implementation
  );

  




  event DebtCeilingChanged(address indexed asset, uint256 ceiling);

  



  event RiskAdminRegistered(address indexed admin);

  



  event RiskAdminUnregistered(address indexed admin);

  



  event BridgeProtocolFeeUpdated(uint256 protocolFee);

  



  event FlashloanPremiumTotalUpdated(uint256 flashloanPremiumTotal);

  



  event FlashloanPremiumToProtocolUpdated(uint256 flashloanPremiumToProtocol);

  



  function initReserves(ConfiguratorInputTypes.InitReserveInput[] calldata input) external;

  



  function updateAToken(ConfiguratorInputTypes.UpdateATokenInput calldata input) external;

  



  function updateStableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
    external;

  



  function updateVariableDebtToken(ConfiguratorInputTypes.UpdateDebtTokenInput calldata input)
    external;

  





  function enableBorrowingOnReserve(
    address asset,
    uint256 borrowCap,
    bool stableBorrowRateEnabled
  ) external;

  



  function disableBorrowingOnReserve(address asset) external;

  








  function configureReserveAsCollateral(
    address asset,
    uint256 ltv,
    uint256 liquidationThreshold,
    uint256 liquidationBonus
  ) external;

  



  function enableReserveStableRate(address asset) external;

  



  function disableReserveStableRate(address asset) external;

  



  function activateReserve(address asset) external;

  



  function deactivateReserve(address asset) external;

  




  function freezeReserve(address asset) external;

  



  function unfreezeReserve(address asset) external;

  




  function setReservePause(address asset, bool val) external;

  




  function setReserveFactor(address asset, uint256 reserveFactor) external;

  




  function setReserveInterestRateStrategyAddress(address asset, address rateStrategyAddress)
    external;

  




  function setPoolPause(bool val) external;

  




  function setBorrowCap(address asset, uint256 borrowCap) external;

  




  function setSupplyCap(address asset, uint256 supplyCap) external;

  




  function setLiquidationProtocolFee(address asset, uint256 fee) external;

  




  function setUnbackedMintCap(address asset, uint256 unbackedMintCap) external;

  




  function setAssetEModeCategory(address asset, uint8 categoryId) external;

  









  function setEModeCategory(
    uint8 categoryId,
    uint16 ltv,
    uint16 liquidationThreshold,
    uint16 liquidationBonus,
    address oracle,
    string calldata label
  ) external;

  



  function dropReserve(address asset) external;

  



  function updateBridgeProtocolFee(uint256 protocolFee) external;

  






  function updateFlashloanPremiumTotal(uint256 flashloanPremiumTotal) external;

  



  function updateFlashloanPremiumToProtocol(uint256 flashloanPremiumToProtocol) external;

  



  function setDebtCeiling(address asset, uint256 ceiling) external;
}