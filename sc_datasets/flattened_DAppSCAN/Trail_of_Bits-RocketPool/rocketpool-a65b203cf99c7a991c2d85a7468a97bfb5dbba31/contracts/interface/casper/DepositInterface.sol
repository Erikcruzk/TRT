// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/interface/casper/DepositInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface DepositInterface {
    function deposit(bytes calldata _pubkey, bytes calldata _withdrawalCredentials, bytes calldata _signature, bytes32 _depositDataRoot) external payable;
}
