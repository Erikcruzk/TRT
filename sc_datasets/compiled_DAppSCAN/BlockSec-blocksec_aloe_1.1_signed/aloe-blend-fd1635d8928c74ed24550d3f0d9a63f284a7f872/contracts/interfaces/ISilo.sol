// File: ../sc_datasets/DAppSCAN/BlockSec-blocksec_aloe_1.1_signed/aloe-blend-fd1635d8928c74ed24550d3f0d9a63f284a7f872/contracts/interfaces/ISilo.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface ISilo {
    function name() external view returns (string memory);

    function poke() external;

    function deposit(uint256 amount) external;

    function withdraw(uint256 amount) external;

    function balanceOf(address account) external view returns (uint256 balance);

    function shouldAllowEmergencySweepOf(address token) external view returns (bool shouldAllow);
}
