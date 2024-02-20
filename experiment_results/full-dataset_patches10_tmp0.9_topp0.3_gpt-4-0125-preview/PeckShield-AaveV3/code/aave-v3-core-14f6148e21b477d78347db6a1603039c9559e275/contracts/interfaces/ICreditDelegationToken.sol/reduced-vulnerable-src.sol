


pragma solidity 0.8.7;






interface ICreditDelegationToken {
  






  event BorrowAllowanceDelegated(
    address indexed fromUser,
    address indexed toUser,
    address asset,
    uint256 amount
  );

  






  function approveDelegation(address delegatee, uint256 amount) external;

  





  function borrowAllowance(address fromUser, address toUser) external view returns (uint256);
}