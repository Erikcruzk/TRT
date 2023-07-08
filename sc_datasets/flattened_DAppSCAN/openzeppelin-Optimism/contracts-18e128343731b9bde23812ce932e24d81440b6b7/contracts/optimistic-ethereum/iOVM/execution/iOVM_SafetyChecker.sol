// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/execution/iOVM_SafetyChecker.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iOVM_SafetyChecker
 */
interface iOVM_SafetyChecker {

    /********************
     * Public Functions *
     ********************/

    function isBytecodeSafe(bytes calldata _bytecode) external pure returns (bool);
}
