


pragma solidity 0.8.2;


contract Owned {
    address public owner;
    address public nominatedOwner;

    constructor(address _owner) public {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner may perform this action");
        _;
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}




pragma solidity 0.8.2;




abstract contract Pausable is Owned {
    uint public lastPauseTime;
    bool public paused;

    constructor() internal {
        
        require(owner != address(0), "Owner must be set");
        
    }

    



    function setPaused(bool _paused) external onlyOwner {
        
        if (_paused == paused) {
            return;
        }

        
        paused = _paused;

        
        if (paused) {
            lastPauseTime = block.timestamp;
        }

        
        emit PauseChanged(paused);
    }

    event PauseChanged(bool isPaused);

    modifier notPaused {
        require(!paused, "This action cannot be performed while the contract is paused");
        _;
    }
}