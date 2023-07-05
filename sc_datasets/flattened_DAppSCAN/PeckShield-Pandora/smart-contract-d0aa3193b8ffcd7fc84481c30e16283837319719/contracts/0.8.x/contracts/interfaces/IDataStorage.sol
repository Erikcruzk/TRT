// File: ../sc_datasets/DAppSCAN/PeckShield-Pandora/smart-contract-d0aa3193b8ffcd7fc84481c30e16283837319719/contracts/0.8.x/contracts/interfaces/IDataStorage.sol

// SPDX-License-Identifier: MIT

pragma solidity =0.8.4;

interface IDataStorage {
    function getPandoBoxCreatingProbability() external view returns (uint256[] memory);
    function getDroidBotCreatingProbability(uint256) external view returns (uint256[] memory);
    function getDroidBotUpgradingProbability(uint256, uint256) external view returns(uint256[] memory);
    function getDroidBotPower(uint256) external view returns(uint256);
    function getJDroidBotCreating(uint256) external view returns(uint256, uint256);
    function getJDroidBotUpgrading(uint256) view external returns(uint256, uint256);
}
