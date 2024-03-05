



pragma solidity >=0.6.0;

interface TokenRecipient {
  
  function tokensReceived(
      address from,
      uint amount,
      bytes calldata exData
  ) external returns (bool);
}