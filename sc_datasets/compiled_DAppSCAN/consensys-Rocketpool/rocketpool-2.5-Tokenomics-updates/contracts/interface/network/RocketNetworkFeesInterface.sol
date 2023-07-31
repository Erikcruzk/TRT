// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/network/RocketNetworkFeesInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketNetworkFeesInterface {
    function getNodeDemand() external view returns (int256);
    function getNodeFee() external view returns (uint256);
    function getNodeFeeByDemand(int256 _nodeDemand) external view returns (uint256);
}
