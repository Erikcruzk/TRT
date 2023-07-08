// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/RocketStorageInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketStorageInterface {

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

}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/network/RocketNetworkFeesInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

interface RocketNetworkFeesInterface {
    function getNodeDemand() external view returns (int256);
    function getNodeFee() external view returns (uint256);
    function getNodeFeeByDemand(int256 _nodeDemand) external view returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/types/MinipoolDeposit.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only

// Represents the type of deposits required by a minipool

enum MinipoolDeposit {
    None,    // Marks an invalid deposit type
    Full,    // The minipool requires 32 ETH from the node operator, 16 ETH of which will be refinanced from user deposits
    Half,    // The minipool required 16 ETH from the node operator to be matched with 16 ETH from user deposits
    Empty    // The minipool requires 0 ETH from the node operator to be matched with 32 ETH from user deposits (trusted nodes only)
}

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/types/MinipoolStatus.sol

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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/contract/minipool/RocketMinipool.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only




// An individual minipool in the Rocket Pool network

contract RocketMinipool {

    // Main Rocket Pool storage contract
    RocketStorageInterface private rocketStorage = RocketStorageInterface(0);

    // Status
    MinipoolStatus private status;
    uint256 private statusBlock;
    uint256 private statusTime;

    // Deposit type
    MinipoolDeposit private depositType;

    // Node details
    address private nodeAddress;
    uint256 private nodeFee;
    uint256 private nodeDepositBalance;
    uint256 private nodeRefundBalance;
    bool private nodeDepositAssigned;
    bool private nodeWithdrawn;

    // User deposit details
    uint256 private userDepositBalance;
    bool private userDepositAssigned;
    uint256 private userDepositAssignedTime;

    // Staking details
    uint256 private stakingStartBalance;
    uint256 private stakingEndBalance;
    bool private validatorBalanceWithdrawn;

    // Events
    event EtherReceived(address indexed from, uint256 amount, uint256 time);

    // Construct
    constructor(address _rocketStorageAddress, address _nodeAddress, MinipoolDeposit _depositType) {
        // Check parameters
        require(_rocketStorageAddress != address(0x0), "Invalid storage address");
        require(_nodeAddress != address(0x0), "Invalid node address");
        require(_depositType != MinipoolDeposit.None, "Invalid deposit type");
        // Initialise RocketStorage
        rocketStorage = RocketStorageInterface(_rocketStorageAddress);
        // Load contracts
        RocketNetworkFeesInterface rocketNetworkFees = RocketNetworkFeesInterface(getContractAddress("rocketNetworkFees"));
        // Set initial status
        status = MinipoolStatus.Initialized;
        statusBlock = block.number;
        statusTime = block.timestamp;
        // Set details
        depositType = _depositType;
        nodeAddress = _nodeAddress;
        nodeFee = rocketNetworkFees.getNodeFee();
    }

    // Receive the minipool's withdrawn eth2 validator balance
    receive() external payable {
        // Emit ether received event
        emit EtherReceived(msg.sender, msg.value, block.timestamp);
    }

    // Delegate all other calls to minipool delegate contract
    fallback(bytes calldata _input) external payable returns (bytes memory) {
        (bool success, bytes memory data) = getContractAddress("rocketMinipoolDelegate").delegatecall(_input);
        if (!success) { revert(getRevertMessage(data)); }
        return data;
    }

    // Get the address of a Rocket Pool network contract
    function getContractAddress(string memory _contractName) private view returns (address) {
        address contractAddress = rocketStorage.getAddress(keccak256(abi.encodePacked("contract.address", _contractName)));
        require(contractAddress != address(0x0), "Contract not found");
        return contractAddress;
    }

    // Get a revert message from delegatecall return data
    function getRevertMessage(bytes memory _returnData) private pure returns (string memory) {
        if (_returnData.length < 68) { return "Transaction reverted silently"; }
        assembly {
            _returnData := add(_returnData, 0x04)
        }
        return abi.decode(_returnData, (string));
    }

}
