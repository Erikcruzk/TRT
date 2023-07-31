// File: ../sc_datasets/DAppSCAN/Chainsulting-1inch/liquidity-protocol-master/contracts/interfaces/IGovernanceModule.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

/// @title Interface for governance notifications
interface IGovernanceModule {
    function notifyStakeChanged(address account, uint256 newBalance) external;
    function notifyStakesChanged(address[] calldata accounts, uint256[] calldata newBalances) external;
}
