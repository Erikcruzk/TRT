// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ICTokenInterface {

  function isCToken() external view returns (bool);

  // function decimals() external returns (uint8);

  // function underlying() external returns (address);

  // function mint(uint mintAmount) external returns (uint);

  // function redeem(uint redeemTokens) external returns (uint);

  // function balanceOf(address user) external view returns (uint);

  // function borrowBalanceCurrent(address account) external returns (uint);

  // function borrowBalanceStored(address account) external view returns (uint);

  // function borrow(uint borrowAmount) external returns (uint);

  // function repayBorrow(uint repayAmount) external returns (uint);
  // function transfer(address dst, uint amount) external returns (bool);
  // function transferFrom(address src, address dst, uint amount) external returns (bool);
  // function approve(address spender, uint amount) external returns (bool);
  // function allowance(address owner, address spender) external view returns (uint);
  // function balanceOf(address owner) external view returns (uint);
  function balanceOfUnderlying(address owner) external view returns (uint);
  function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
  function borrowRatePerBlock() external view returns (uint);
  function supplyRatePerBlock() external view returns (uint);
  function totalBorrowsCurrent() external returns (uint);
  function borrowBalanceCurrent(address account) external returns (uint);
  function borrowBalanceStored(address account) external view returns (uint);
  function exchangeRateCurrent() external returns (uint);
  function exchangeRateStored() external view returns (uint);
  function getCash() external view returns (uint);
  function accrueInterest() external returns (uint);
  function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
}
