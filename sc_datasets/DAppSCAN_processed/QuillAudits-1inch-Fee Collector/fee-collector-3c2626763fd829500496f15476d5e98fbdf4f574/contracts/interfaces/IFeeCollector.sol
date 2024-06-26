// File: ../sc_datasets/DAppSCAN/QuillAudits-1inch-Fee Collector/fee-collector-3c2626763fd829500496f15476d5e98fbdf4f574/contracts/interfaces/IFeeCollector.sol

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


interface IFeeCollector {
    function updateReward(address referral, uint256 amount) external;
}
