

















pragma solidity 0.5.12;

interface IDelegateFactory {

  event CreateDelegate(
    address indexed delegateContract,
    address swapContract,
    address indexerContract,
    address indexed delegateContractOwner,
    address delegateTradeWallet
  );

  





  function createDelegate(
    address delegateContractOwner,
    address delegateTradeWallet
  ) external returns (address delegateContractAddress);
}