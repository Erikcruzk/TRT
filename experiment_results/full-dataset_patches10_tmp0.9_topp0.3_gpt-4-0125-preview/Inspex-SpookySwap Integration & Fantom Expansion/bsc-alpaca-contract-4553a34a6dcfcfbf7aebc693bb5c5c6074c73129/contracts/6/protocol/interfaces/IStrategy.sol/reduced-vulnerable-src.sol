














pragma solidity 0.6.6;

interface IStrategy {
  
  
  
  
  function execute(address user, uint256 debt, bytes calldata data) external;
}