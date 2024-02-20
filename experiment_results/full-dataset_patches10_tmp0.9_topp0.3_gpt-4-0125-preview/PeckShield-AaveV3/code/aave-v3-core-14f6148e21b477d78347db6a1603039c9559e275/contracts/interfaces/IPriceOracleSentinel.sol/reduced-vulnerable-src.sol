


pragma solidity 0.8.7;






interface IPriceOracleSentinel {
  




  function isBorrowAllowed() external view returns (bool);

  




  function isLiquidationAllowed() external view returns (bool);
}