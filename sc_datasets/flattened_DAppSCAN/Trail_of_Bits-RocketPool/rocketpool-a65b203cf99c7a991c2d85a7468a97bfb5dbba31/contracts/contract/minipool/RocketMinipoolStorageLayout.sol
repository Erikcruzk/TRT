// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/interface/RocketStorageInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketStorageInterface {

    // Guardian
    function getGuardian() external view returns(address);
    function setGuardian(address _newAddress) external;
    function confirmGuardian() external;

    // Getters
    function getAddress(bytes32 _key) external view returns (address);
    function getUint(bytes32 _key) external view returns (uint);
    function getString(bytes32 _key) external view returns (string memory);
    function getBytes(bytes32 _key) external view returns (bytes memory);
    function getBool(bytes32 _key) external view returns (bool);
    function getInt(bytes32 _key) external view returns (int);
    function getBytes32(bytes32 _key) external view returns (bytes32);

    // Setters
    function setAddress(bytes32 _key, address _value) external;
    function setUint(bytes32 _key, uint _value) external;
    function setString(bytes32 _key, string calldata _value) external;
    function setBytes(bytes32 _key, bytes calldata _value) external;
    function setBool(bytes32 _key, bool _value) external;
    function setInt(bytes32 _key, int _value) external;
    function setBytes32(bytes32 _key, bytes32 _value) external;

    // Deleters
    function deleteAddress(bytes32 _key) external;
    function deleteUint(bytes32 _key) external;
    function deleteString(bytes32 _key) external;
    function deleteBytes(bytes32 _key) external;
    function deleteBool(bytes32 _key) external;
    function deleteInt(bytes32 _key) external;
    function deleteBytes32(bytes32 _key) external;

    // Arithmetic
    function addUint(bytes32 _key, uint256 _amount) external;
    function subUint(bytes32 _key, uint256 _amount) external;

    // Protected storage
    function getNodeWithdrawalAddress(address _nodeAddress) external view returns (address);
    function getNodePendingWithdrawalAddress(address _nodeAddress) external view returns (address);
    function setWithdrawalAddress(address _nodeAddress, address _newWithdrawalAddress, bool _confirm) external;
    function confirmWithdrawalAddress(address _nodeAddress) external;
}

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

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/types/MinipoolStatus.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

// Represents a minipool's status within the network

enum MinipoolStatus {
    Initialized,    // The minipool has been initialized and is awaiting a deposit of user ETH
    Prelaunch,      // The minipool has enough ETH to begin staking and is awaiting launch by the node operator
    Staking,        // The minipool is currently staking
    Withdrawable,   // The minipool has become withdrawable on the beacon chain and can be withdrawn from by the node operator
    Dissolved       // The minipool has been dissolved and its user deposited ETH has been returned to the deposit pool
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-RocketPool/rocketpool-a65b203cf99c7a991c2d85a7468a97bfb5dbba31/contracts/contract/minipool/RocketMinipoolStorageLayout.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only



// The RocketMinipool contract storage layout, shared by RocketMinipoolDelegate

// ******************************************************
// Note: This contract MUST NOT BE UPDATED after launch.
// All deployed minipool contracts must maintain a
// Consistent storage layout with RocketMinipoolDelegate.
// ******************************************************

abstract contract RocketMinipoolStorageLayout {
    // Storage state enum
    enum StorageState {
        Undefined,
        Uninitialised,
        Initialised
    }

	// Main Rocket Pool storage contract
    RocketStorageInterface internal rocketStorage = RocketStorageInterface(0);

    // Status
    MinipoolStatus internal status;
    uint256 internal statusBlock;
    uint256 internal statusTime;
    uint256 internal withdrawalBlock;

    // Deposit type
    MinipoolDeposit internal depositType;

    // Node details
    address internal nodeAddress;
    uint256 internal nodeFee;
    uint256 internal nodeDepositBalance;
    bool internal nodeDepositAssigned;
    uint256 internal nodeRefundBalance;
    uint256 internal nodeSlashBalance;

    // User deposit details
    uint256 internal userDepositBalance;
    uint256 internal userDepositAssignedTime;

    // Upgrade options
    bool internal useLatestDelegate = false;
    address internal rocketMinipoolDelegate;
    address internal rocketMinipoolDelegatePrev;

    // Local copy of RETH address
    address internal rocketTokenRETH;

    // Local copy of penalty contract
    address internal rocketMinipoolPenalty;

    // Used to prevent direct access to delegate and prevent calling initialise more than once
    StorageState storageState = StorageState.Undefined;

    // Whether node operator has finalised the pool
    bool internal finalised;
}
