// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-FraxQ42021/frax-solidity-bd40775e283923aa9e32a107abd426430a99835e/src/hardhat/contracts/Misc_AMOs/olympus/IStakingHelper.sol

// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.6.11;

interface IStakingHelper {
  function OHM() external view returns (address);
  function stake(uint256 _amount) external;
  function staking() external view returns (address);
}
