// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/precompiles/iOVM_L2ToL1MessagePasser.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iOVM_L2ToL1MessagePasser
 */
interface iOVM_L2ToL1MessagePasser {

    /**********
     * Events *
     **********/

    event L2ToL1Message(
        uint256 _nonce,
        address _sender,
        bytes _data
    );


    /********************
     * Public Functions *
     ********************/

    function passMessageToL1(bytes calldata _message) external;
}
