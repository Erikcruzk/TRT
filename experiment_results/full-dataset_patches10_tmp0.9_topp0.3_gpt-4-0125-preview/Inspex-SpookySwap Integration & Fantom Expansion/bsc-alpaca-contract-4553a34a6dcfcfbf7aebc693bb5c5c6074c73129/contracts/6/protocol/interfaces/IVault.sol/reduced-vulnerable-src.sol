














pragma solidity 0.6.6;

interface IVault {
  
  function totalToken() external view returns (uint256);

  
  function deposit(uint256 amountToken) external payable;

  
  function withdraw(uint256 share) external;

  
  function requestFunds(address targetedToken, uint256 amount) external;

  
  function token() external view returns (address);
}