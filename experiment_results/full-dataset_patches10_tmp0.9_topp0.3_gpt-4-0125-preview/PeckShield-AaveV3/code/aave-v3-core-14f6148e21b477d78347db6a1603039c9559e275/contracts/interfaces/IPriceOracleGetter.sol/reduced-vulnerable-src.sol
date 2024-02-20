


pragma solidity 0.8.7;






interface IPriceOracleGetter {
  



  function BASE_CURRENCY() external view returns (address);

  



  function BASE_CURRENCY_UNIT() external view returns (uint256);

  




  function getAssetPrice(address asset) external view returns (uint256);
}