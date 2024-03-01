// File: ../sc_datasets/DAppSCAN/Chainsulting-Global Rockstar/openzeppelin-contracts-upgradeable-master/contracts/vendor/polygon/IFxMessageProcessorUpgradeable.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (vendor/polygon/IFxMessageProcessor.sol)
pragma solidity ^0.8.0;

interface IFxMessageProcessorUpgradeable {
    function processMessageFromRoot(
        uint256 stateId,
        address rootMessageSender,
        bytes calldata data
    ) external;
}