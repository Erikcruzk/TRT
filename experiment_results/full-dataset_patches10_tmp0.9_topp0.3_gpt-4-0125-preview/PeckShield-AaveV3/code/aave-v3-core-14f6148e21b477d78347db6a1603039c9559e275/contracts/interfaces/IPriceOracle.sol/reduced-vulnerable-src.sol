


pragma solidity 0.8.7;






interface IPriceOracle {
  




  function getAssetPrice(address asset) external view returns (uint256);

  




  function setAssetPrice(address asset, uint256 price) external;
}