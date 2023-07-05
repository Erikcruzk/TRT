// File: ../sc_datasets/DAppSCAN/consensys-Gamma/hypervisor-41fd4abf79864478523e87924d4e80d80df04879/contracts/interfaces/IUniProxy.sol

pragma solidity =0.7.6;
pragma abicoder v2;

interface IUniProxy {

  function deposit(
    uint256 deposit0,
    uint256 deposit1,
    address to,
    address from,
    address pos
  ) external returns (uint256 shares);

  function getDepositAmount(address token, uint256 deposit)
  external view
  returns (uint256 amountStart, uint256 amountEnd);

}
