// File: ../sc_datasets/DAppSCAN/PeckShield-Holdefi/Holdefi-5a1e6e0d582120142e8a531f6806eba6665ef2f4/contracts/HoldefiOwnable.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;

/// @title HoldefiOwnable
/// @author Holdefi Team
/// @notice Taking ideas from Open Zeppelin's Ownable contract
/// @dev Contract module which provides a basic access control mechanism, where
/// there is an account (an owner) that can be granted exclusive access to
/// specific functions.
///
/// By default, the owner account will be the one that deploys the contract. This
/// can later be changed with {transferOwnership}.
///
/// This module is used through inheritance. It will make available the modifier
/// `onlyOwner`, which can be applied to your functions to restrict their use to
/// the owner.
contract HoldefiOwnable {
    address public owner;
    address public pendingOwner;

    /// @notice Event emitted when an ownership transfer request is recieved
    event OwnershipTransferRequested(address newPendingOwner);

    /// @notice Event emitted when an ownership transfer request is accepted by the pending owner
    event OwnershipTransferred(address newOwner, address oldOwner);

    /// @notice Initializes the contract owner
    constructor () public {
        owner = msg.sender;
        emit OwnershipTransferred(owner, address(0));
    }

    /// @notice Throws if called by any account other than the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender should be owner");
        _;
    }

    /// @notice Transfers ownership of the contract to a new owner
    /// @dev Can only be called by the current owner
    /// @param newOwner Address of new owner
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner can not be zero address");
        pendingOwner = newOwner;

        emit OwnershipTransferRequested(newOwner);
    }

    /// @notice Pending owner accepts ownership of the contract
    /// @dev Only Pending owner can call this function
    function acceptTransferOwnership () external {
        require (pendingOwner != address(0), "Pending owner is empty");
        require (pendingOwner == msg.sender, "Pending owner is not same as sender");
        
        emit OwnershipTransferred(pendingOwner, owner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

// File: ../sc_datasets/DAppSCAN/PeckShield-Holdefi/Holdefi-5a1e6e0d582120142e8a531f6806eba6665ef2f4/contracts/HoldefiPausableOwnable.sol

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

/// @title HoldefiPausableOwnable
/// @author Holdefi Team
/// @notice Taking ideas from Open Zeppelin's Pausable contract
/// @dev Base contract which allows children to implement an emergency stop mechanism.
contract HoldefiPausableOwnable is HoldefiOwnable {

    uint256 constant public maxPauseDuration = 2592000;     //seconds per month

    struct Operation {
        bool isValid;
        uint256 pauseEndTime;
    }

    /// @notice Pauser can pause operations but can't unpause them
    address public pauser;

    mapping(string => Operation) public paused;

    /// @notice Event emitted when the pauser is changed by the owner
    event PauserChanged(address newPauser, address oldPauser);

    /// @notice Event emitted when an operation is paused by the pauser
    event OperationPaused(string operation, uint256 pauseDuration);

    /// @notice Event emitted when an operation is unpaused by the owner
    event OperationUnpaused(string operation);
    
    /// @notice Define valid operations that can be paused
    constructor () public {
        paused["supply"].isValid = true;
        paused["withdrawSupply"].isValid = true;
        paused["collateralize"].isValid = true;
        paused["withdrawCollateral"].isValid = true;
        paused["borrow"].isValid = true;
        paused["repayBorrow"].isValid = true;
        paused["liquidateBorrowerCollateral"].isValid = true;
        paused["buyLiquidatedCollateral"].isValid = true;
    }

    /// @dev Modifier to make a function callable only by owner or pauser
    modifier onlyPausers() {
        require(msg.sender == owner || msg.sender == pauser , "Sender should be owner or pauser");
        _;
    }
    
    /// @dev Modifier to make a function callable only when an operation is not paused
    /// @param operation Name of the operation
    modifier whenNotPaused(string memory operation) {
        require(!isPaused(operation), "Operation is paused");
        _;
    }

    /// @dev Modifier to make a function callable only when an operation is paused
    /// @param operation Name of the operation
    modifier whenPaused(string memory operation) {
        require(isPaused(operation), "Operation is unpaused");
        _;
    }

    /// @dev Modifier to make a function callable only when an operation is valid
    /// @param operation Name of the operation
    modifier operationIsValid(string memory operation) {
        require(paused[operation].isValid ,"Operation is not valid");
        _;
    }

    /// @notice Returns the pause status of a given operation
    /// @param operation Name of the operation
    /// @return res Pause status of a given operation
    function isPaused(string memory operation) public view returns (bool res) {
        if (block.timestamp > paused[operation].pauseEndTime) {
            res = false;
        }
        else {
            res = true;
        }
    }

    /// @notice Called by pausers to pause an operation, triggers stopped state
    /// @param operation Name of the operation
    /// @param pauseDuration The length of time the operation must be paused
    function pause(string memory operation, uint256 pauseDuration)
        public
        onlyPausers
        operationIsValid(operation)
        whenNotPaused(operation)
    {
        require (pauseDuration <= maxPauseDuration, "Duration not in range");
        paused[operation].pauseEndTime = block.timestamp + pauseDuration;
        emit OperationPaused(operation, pauseDuration);
    }

    /// @notice Called by owner to unpause an operation, returns to normal state
    /// @param operation Name of the operation
    function unpause(string memory operation)
        public
        onlyOwner
        operationIsValid(operation)
        whenPaused(operation)
    {
        paused[operation].pauseEndTime = 0;
        emit OperationUnpaused(operation);
    }

    /// @notice Called by pausers to pause operations, triggers stopped state for selected operations
    /// @param operations List of operation names
    /// @param pauseDurations List of durations specifying the pause time of each operation
    function batchPause(string[] memory operations, uint256[] memory pauseDurations) external {
        require (operations.length == pauseDurations.length, "Lists are not equal in length");
        for (uint256 i = 0 ; i < operations.length ; i++) {
            pause(operations[i], pauseDurations[i]);
        }
    }

    /// @notice Called by pausers to pause operations, returns to normal state for selected operations
    /// @param operations List of operation names
    function batchUnpause(string[] memory operations) external {
        for (uint256 i = 0 ; i < operations.length ; i++) {
            unpause(operations[i]);
        }
    }

    /// @notice Called by owner to set a new pauser
    /// @param newPauser Address of new pauser
    function setPauser(address newPauser) external onlyOwner {
        emit PauserChanged(newPauser, pauser);
        pauser = newPauser;
        
    }

}
