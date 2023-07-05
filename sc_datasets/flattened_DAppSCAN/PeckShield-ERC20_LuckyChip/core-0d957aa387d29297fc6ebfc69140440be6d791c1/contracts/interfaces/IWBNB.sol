// File: ../sc_datasets/DAppSCAN/PeckShield-ERC20_LuckyChip/core-0d957aa387d29297fc6ebfc69140440be6d791c1/contracts/interfaces/IWBNB.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

interface IWBNB {
    function deposit() external payable;
    function transfer(address to, uint256 value) external returns (bool);
    function withdraw(uint256) external;
}
