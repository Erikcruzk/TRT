// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-dharma-smartwallet/dharma-smart-wallet-b1d510d03b97a9c8457b9c0b9c91568a09ccc95d/contracts/upgradeability/smart-wallet/DharmaUpgradeBeacon.sol

pragma solidity 0.5.11;


/**
 * @title DharmaUpgradeBeacon
 * @author 0age
 * @notice This contract holds the address of the current implementation for
 * Dharma smart wallets and lets a controller update that address in storage.
 */
contract DharmaUpgradeBeacon {
  // The implementation address is held in storage slot zero.
  address private _implementation;

  // The controller that can update the implementation is set as a constant.
  address private constant _CONTROLLER = address(
    0x00000000002226C940b74d674B85E4bE05539663
  );

  /**
   * @notice In the fallback function, allow only the controller to update the
   * implementation address - for all other callers, return the current address.
   * Note that this requires inline assembly, as Solidity fallback functions do
   * not natively take arguments or return values.
   */
  function () external {
    // Return implementation address for all callers other than the controller.
    if (msg.sender != _CONTROLLER) {
      // Load implementation from storage slot zero into memory and return it.
      assembly {
        mstore(0, sload(0))
        return(0, 32)
      }
    } else {
      // Set implementation - put first word in calldata in storage slot zero.
      assembly { sstore(0, calldataload(0)) }
    }
  }
}