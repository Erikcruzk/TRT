// File: ../sc_datasets/DAppSCAN/PeckShield-Metatime/metatime-6fd2d5b132377b007c3baa79938a53132fd2f955/contracts/interfaces/IvDsgToken.sol

// SPDX-License-Identifier: MIT

pragma solidity =0.6.12;

interface IvDsgToken {
    function donate(uint256 dsgAmount) external;
    function redeem(uint256 vDsgAmount, bool all) external;
    function balanceOf(address account) external view returns (uint256 vDsgAmount);
}
