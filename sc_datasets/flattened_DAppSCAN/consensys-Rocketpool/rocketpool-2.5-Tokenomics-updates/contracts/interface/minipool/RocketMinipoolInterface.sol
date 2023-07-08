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

// File: ../sc_datasets/DAppSCAN/consensys-Rocketpool/rocketpool-2.5-Tokenomics-updates/contracts/interface/minipool/RocketMinipoolInterface.sol

pragma solidity 0.7.6;

// SPDX-License-Identifier: GPL-3.0-only


interface RocketMinipoolInterface {
    function getStatus() external view returns (MinipoolStatus);
    function getStatusBlock() external view returns (uint256);
    function getStatusTime() external view returns (uint256);
    function getDepositType() external view returns (MinipoolDeposit);
    function getNodeAddress() external view returns (address);
    function getNodeFee() external view returns (uint256);
    function getNodeDepositBalance() external view returns (uint256);
    function getNodeRefundBalance() external view returns (uint256);
    function getNodeDepositAssigned() external view returns (bool);
    function getNodeWithdrawn() external view returns (bool);
    function getUserDepositBalance() external view returns (uint256);
    function getUserDepositAssigned() external view returns (bool);
    function getUserDepositAssignedTime() external view returns (uint256);
    function getStakingStartBalance() external view returns (uint256);
    function getStakingEndBalance() external view returns (uint256);
    function getValidatorBalanceWithdrawn() external view returns (bool);
    function getWithdrawalCredentials() external view returns (bytes memory);
    function nodeDeposit() external payable;
    function userDeposit() external payable;
    function payout() payable external;
    function refund() external;
    function stake(bytes calldata _validatorPubkey, bytes calldata _validatorSignature, bytes32 _depositDataRoot) external;
    function setWithdrawable(uint256 _stakingStartBalance, uint256 _stakingEndBalance) external;
    function withdraw() external;
    function dissolve() external;
    function close() external;
}
