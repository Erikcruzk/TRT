

pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;


contract GovernorBravoEvents {
    
    event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);

    
    
    
    
    
    
    event VoteCast(address indexed voter, uint proposalId, uint8 support, uint votes, string reason);

    
    event ProposalCanceled(uint id);

    
    event ProposalQueued(uint id, uint eta);

    
    event ProposalExecuted(uint id);

    
    event VotingDelaySet(uint oldVotingDelay, uint newVotingDelay);

    
    event VotingPeriodSet(uint oldVotingPeriod, uint newVotingPeriod);

    
    event NewImplementation(address oldImplementation, address newImplementation);

    
    event ProposalThresholdSet(uint oldProposalThreshold, uint newProposalThreshold);

    
    event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

    
    event NewAdmin(address oldAdmin, address newAdmin);
}

contract GovernorBravoDelegatorStorage {
    
    address public admin;

    
    address public pendingAdmin;

    
    address public implementation;
}








contract GovernorBravoDelegateStorageV1 is GovernorBravoDelegatorStorage {

    
    uint public votingDelay;

    
    uint public votingPeriod;

    
    uint public proposalThreshold;

    
    uint public initialProposalId;

    
    uint public proposalCount;

    
    TimelockInterface public timelock;

    
    CompInterface public comp;

    
    mapping (uint => Proposal) public proposals;

    
    mapping (address => uint) public latestProposalIds;


    struct Proposal {
        
        uint id;

        
        address proposer;

        
        uint eta;

        
        address[] targets;

        
        uint[] values;

        
        string[] signatures;

        
        bytes[] calldatas;

        
        uint startBlock;

        
        uint endBlock;

        
        uint forVotes;

        
        uint againstVotes;

        
        uint abstainVotes;

        
        bool canceled;

        
        bool executed;

        
        mapping (address => Receipt) receipts;
    }

    
    struct Receipt {
        
        bool hasVoted;

        
        uint8 support;

        
        uint96 votes;
    }

    
    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed
    }
}

interface TimelockInterface {
    function delay() external view returns (uint);
    function GRACE_PERIOD() external view returns (uint);
    function acceptAdmin() external;
    function queuedTransactions(bytes32 hash) external view returns (bool);
    function queueTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external returns (bytes32);
    function cancelTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external;
    function executeTransaction(address target, uint value, string calldata signature, bytes calldata data, uint eta) external payable returns (bytes memory);
}

interface CompInterface {
    function getPriorVotes(address account, uint blockNumber) external view returns (uint96);
}

interface IGovernorAlpha {
    
    function proposalCount() external returns (uint);
}