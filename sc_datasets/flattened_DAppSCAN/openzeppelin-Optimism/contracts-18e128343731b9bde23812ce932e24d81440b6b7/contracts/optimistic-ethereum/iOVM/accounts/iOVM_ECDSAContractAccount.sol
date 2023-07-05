// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/accounts/iOVM_ECDSAContractAccount.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/**
 * @title iOVM_ECDSAContractAccount
 */
interface iOVM_ECDSAContractAccount {

    /********************
     * Public Functions *
     ********************/

    function execute(
        bytes memory _encodedTransaction
    )
        external
        returns (
            bool,
            bytes memory
        );
}
