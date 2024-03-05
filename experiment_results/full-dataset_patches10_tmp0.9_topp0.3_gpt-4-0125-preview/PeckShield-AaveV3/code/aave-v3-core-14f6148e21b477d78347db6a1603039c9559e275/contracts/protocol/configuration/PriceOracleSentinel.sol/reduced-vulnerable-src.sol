


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






interface IPriceOracleSentinel {
  




  function isBorrowAllowed() external view returns (bool);

  




  function isLiquidationAllowed() external view returns (bool);
}




pragma solidity 0.8.7;






interface ISequencerOracle {
  function latestAnswer() external view returns (bool, uint256);
}




pragma solidity 0.8.7;









contract PriceOracleSentinel is IPriceOracleSentinel {
  IPoolAddressesProvider public _addressesProvider;
  ISequencerOracle public _oracle;
  uint256 public _gracePeriod;

  





  constructor(
    IPoolAddressesProvider provider,
    ISequencerOracle oracle,
    uint256 gracePeriod
  ) {
    _addressesProvider = provider;
    _oracle = oracle;
    _gracePeriod = gracePeriod;
  }

  
  function isBorrowAllowed() public view override returns (bool) {
    return _isUpAndGracePeriodPassed();
  }

  
  function isLiquidationAllowed() public view override returns (bool) {
    return _isUpAndGracePeriodPassed();
  }

  function _isUpAndGracePeriodPassed() internal view returns (bool) {
    (bool isDown, uint256 timestampGotUp) = _oracle.latestAnswer();
    return !isDown && block.timestamp - timestampGotUp > _gracePeriod;
  }
}