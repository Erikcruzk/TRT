// File: ../sc_datasets/DAppSCAN/consensys-Gamma/hypervisor-41fd4abf79864478523e87924d4e80d80df04879/contracts/adapters/tokemak/interfaces/IUniProxy.sol

pragma solidity =0.6.11;
pragma experimental ABIEncoderV2;

interface IUniProxy {

  function deposit(
    uint256 deposit0,
    uint256 deposit1,
    address to,
    address from,
    address pos
  ) external returns (uint256 shares);

}
