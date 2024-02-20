














pragma solidity 0.6.6;

interface PriceOracle {
  
  
  function getPrice(address token0, address token1) external view returns (uint256 price, uint256 lastUpdate);
}