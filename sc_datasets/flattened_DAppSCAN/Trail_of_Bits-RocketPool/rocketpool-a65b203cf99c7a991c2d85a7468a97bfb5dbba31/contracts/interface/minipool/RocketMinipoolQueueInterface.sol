// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/types/MinipoolDeposit.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

// Represents the type of deposits required by a minipool

enum MinipoolDeposit {
    None,    // Marks an invalid deposit type
    Full,    // The minipool requires 32 ETH from the node operator, 16 ETH of which will be refinanced from user deposits
    Half,    // The minipool required 16 ETH from the node operator to be matched with 16 ETH from user deposits
    Empty    // The minipool requires 0 ETH from the node operator to be matched with 32 ETH from user deposits (trusted nodes only)
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/interface/minipool/RocketMinipoolQueueInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketMinipoolQueueInterface {
    function getTotalLength() external view returns (uint256);
    function getLength(MinipoolDeposit _depositType) external view returns (uint256);
    function getTotalCapacity() external view returns (uint256);
    function getEffectiveCapacity() external view returns (uint256);
    function getNextCapacity() external view returns (uint256);
    function getNextDeposit() external view returns (MinipoolDeposit, uint256);
    function enqueueMinipool(MinipoolDeposit _depositType, address _minipool) external;
    function dequeueMinipool() external returns (address minipoolAddress);
    function dequeueMinipoolByDeposit(MinipoolDeposit _depositType) external returns (address minipoolAddress);
    function removeMinipool(MinipoolDeposit _depositType) external;
}