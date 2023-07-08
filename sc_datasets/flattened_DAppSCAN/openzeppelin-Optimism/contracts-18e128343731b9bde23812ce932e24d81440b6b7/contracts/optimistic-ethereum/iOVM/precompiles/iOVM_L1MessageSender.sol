// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/precompiles/iOVM_L1MessageSender.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iOVM_L1MessageSender
 */
interface iOVM_L1MessageSender {

    /********************
     * Public Functions *
     ********************/

    function getL1MessageSender() external view returns (address _l1MessageSender);
}
