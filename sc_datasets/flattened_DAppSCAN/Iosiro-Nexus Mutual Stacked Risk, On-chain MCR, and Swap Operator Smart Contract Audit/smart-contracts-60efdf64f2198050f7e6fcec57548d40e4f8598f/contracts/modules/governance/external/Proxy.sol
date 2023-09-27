// File: ../sc_datasets/DAppSCAN/Iosiro-Nexus Mutual Stacked Risk, On-chain MCR, and Swap Operator Smart Contract Audit/smart-contracts-60efdf64f2198050f7e6fcec57548d40e4f8598f/contracts/modules/governance/external/Proxy.sol

pragma solidity ^0.5.0;


/**
 * @title Proxy
 * @dev Gives the possibility to delegate any call to a foreign implementation.
 */
contract Proxy {

  /**
  * @dev Fallback function allowing to perform a delegatecall to the given implementation.
  * This function will return whatever the implementation call returns
  */
  // solhint-disable-next-line no-complex-fallback
  function() external payable {
    address _impl = implementation();
    require(_impl != address(0));

    // solhint-disable-next-line no-inline-assembly
    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
      case 0 {revert(ptr, size)}
      default {return (ptr, size)}
    }
  }

  /**
  * @dev Tells the address of the implementation where every call will be delegated.
  * @return address of the implementation to which it will be delegated
  */
  function implementation() public view returns (address);
}