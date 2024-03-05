







pragma solidity >=0.6.0 <0.8.0;

interface MSiG {

    function owners() external view returns (address[] memory addresses, uint256[] memory vPowers);
    function request() external view returns (address destination, uint256 value, bytes memory data);
    function requestProgress() external view returns (uint32 requestId, uint64 timestamp, uint16 currentVote, uint16 requiredVote);
    function voteRequirement() external view returns (uint16 requiredVote, uint16 totalVote);
    function hasVoted(address owner) external view returns (bool voted, uint16 vPower);
    function createRequest(address destination, uint256 value, bytes memory data) external returns (bool);
    function vote() external returns (bool);
    function cancelRequest() external returns (bool);
    function changeOwners(address[] memory nOwners, uint16[] memory vPowers, uint16 vRate) external returns (bool);

    event Requested(uint256 requestId, address indexed destination, uint256 value, bytes data, uint16 currentVote, uint16 requiredVote);
    event Voted(address owner, uint256 requestId, uint16 currentVote, uint16 requiredVote);
    event Executed(bool status, uint256 requestId, address indexed destination, uint256 value, bytes data);
    event Cancelled(uint256 requestId);
    event OwnersChanged(address[] owners, uint16 requireVote, uint16 totalVote);
    event Deposited(address indexed sender, uint256 value);
}

contract C98MSiG is MSiG {

    address[] private _owners;
    mapping(address => uint16) private _votePowers;
    VoteRequirement private _voteRequirement;

    uint32 private _requestId;
    Request private _request;
    mapping(address => uint32) private _votes;
    VoteProgress private _voteProgress;

    
    
    
    
    constructor(address[] memory owners_, uint16[] memory vPowers_, uint16 requiredVote_) {
        _changeOwners(owners_, vPowers_, requiredVote_);
    }

    
    struct Request {
        address destination;
        uint256 value;
        bytes data;
    }

    
    struct VoteProgress {
        uint32 requestId;
        uint64 timestamp;
        uint16 currentVote;
        uint16 requiredVote;
    }

    
    struct VoteRequirement {
        uint16 requiredVote;
        uint16 totalVote;
    }

    modifier selfOnly() {
        require(msg.sender == address(this), "C98MSiG: Wallet only");
        _;
    }

    modifier isOwner(address owner) {
        require(_votePowers[owner] > 0, "C98MSiG: Not an owner");
        _;
    }

    modifier notOwner(address owner) {
        require(_votePowers[owner] == 0, "C98MSiG: Already an owner");
        _;
    }

    modifier validVotingPower(uint256 vPower) {
        require(vPower > 0, "C98MSiG: Invalid vote weight");
        _;
    }

    fallback() external payable {
        if (msg.value > 0) {
            emit Deposited(msg.sender, msg.value);
        }
    }

    
    receive() external payable {
        if (msg.value > 0) {
            emit Deposited(msg.sender, msg.value);
        }
    }

    
    
    
    function owners() external view override returns (address[] memory addresses, uint256[] memory vPowers) {
        uint256[] memory values = new uint256[](_owners.length);
        uint256 i;
        for (i = 0; i < _owners.length; i++) {
            values[i] = (_votePowers[_owners[i]]);
        }
        return (_owners, values);
    }

    
    
    
    
    function request() external view override returns (address destination, uint256 value, bytes memory data) {
        Request memory req = _request;
        return (req.destination, req.value, req.data);
    }

    
    
    
    
    
    function requestProgress() external view override returns (uint32 requestId, uint64 timestamp, uint16 currentVote, uint16 requiredVote) {
        VoteProgress memory progress = _voteProgress;
        return (progress.requestId, progress.timestamp, progress.currentVote, progress.requiredVote);
    }

    
    
    
    function voteRequirement() external view override returns (uint16 requiredVote, uint16 totalVote) {
        VoteRequirement memory requirement = _voteRequirement;
        return (requirement.requiredVote, requirement.totalVote);
    }

    
    
    
    function hasVoted(address owner) external view override returns (bool voted, uint16 vPower) {
        VoteProgress memory progress = _voteProgress;
        uint16 power = _votePowers[owner];
        if (progress.requestId == 0) {
            return (false, power);
        }
        return (progress.requestId == _votes[owner], power);
    }

    
    
    
    
    function createRequest(address destination, uint256 value, bytes memory data)
        isOwner(msg.sender)
        external override returns (bool) {
        VoteProgress memory progress = _voteProgress;
        require(progress.requestId == 0, "C98MSiG: Request pending");

        Request memory req;
        req.destination = destination;
        req.value = value;
        req.data = data;
        progress.requestId = _requestId + 1;
        progress.timestamp = uint64(block.timestamp);
        progress.requiredVote = _voteRequirement.requiredVote;
        _request = req;
        _requestId = progress.requestId;
        _voteProgress = progress;
        vote();

        emit Requested(progress.requestId, req.destination, req.value, req.data, progress.currentVote, progress.requiredVote);
        return true;
    }

    
    
    function vote()
        isOwner(msg.sender)
        public override returns (bool) {
        VoteProgress memory progress = _voteProgress;
        require(progress.requestId > 0, "C98MSiG: No pending request");
        if (_votes[msg.sender] < progress.requestId) {
            _votes[msg.sender] = progress.requestId;
            progress.currentVote += _votePowers[msg.sender];
            _voteProgress = progress;
            emit Voted(msg.sender, progress.requestId, progress.currentVote, progress.requiredVote);
        }
        if (progress.currentVote >= progress.requiredVote) {
            Request memory req = _request;
            (bool success,) = req.destination.call{value: req.value}(req.data);
            if (success) {
                delete _request;
                delete _voteProgress;
                Executed(true, progress.requestId, req.destination, req.value, req.data);
            }
            else {
                Executed(false, progress.requestId, req.destination, req.value, req.data);
            }
        }
        return true;
    }

    
    function cancelRequest()
        isOwner(msg.sender)
        external override returns (bool) {
        VoteProgress memory progress = _voteProgress;
        require(progress.requestId > 0, "C98MSiG: No pending request");
        require(block.timestamp - progress.timestamp > 600, "C98MSiG: 10 mins not passed");

        delete _request;
        delete _voteProgress;

        emit Cancelled(progress.requestId);
        return true;
    }

    
    
    
    
    
    function changeOwners(address[] memory nOwners, uint16[] memory vPowers, uint16 vRate)
        selfOnly()
        external override returns (bool) {
        _changeOwners(nOwners, vPowers, vRate);
        return true;
    }

    function _changeOwners(address[] memory nOwners, uint16[] memory vPowers, uint16 vRate) internal {
        VoteRequirement memory requirement = _voteRequirement;
        uint256 i;
        for (i = 0; i < nOwners.length; i++) {
            address nOwner = nOwners[i];
            uint16 cPower = _votePowers[nOwner];
            uint16 vPower = vPowers[i];
            require(vPower <= 256, "C98MSiG: Invalid vRate");
            if (cPower > 0) {
                if (vPower == 0) {
                    uint256 j;
                    for(j = 0; j < _owners.length; j++) {
                        if (_owners[j] == nOwner) {
                            _owners[j] = _owners[_owners.length - 1];
                            _owners.pop();
                            delete _votes[nOwner];
                            break;
                        }
                    }
                }
                requirement.totalVote -= cPower;
            }
            else {
                if (vPower > 0) {
                    _owners.push(nOwner);
                }
            }
            _votePowers[nOwner] = vPower;
            requirement.totalVote += vPower;
        }
        if (vRate > 0) {
            requirement.requiredVote = vRate;
        }
        uint256 ownerCount = _owners.length;
        require(requirement.requiredVote > 0, "C98MSiG: Invalid vRate");
        require(requirement.requiredVote <= requirement.totalVote, "C98MSiG: Invalid vRate");
        require(requirement.totalVote <= 4096, "C98MSiG: Max weight reached");
        require(ownerCount > 0, "C98MSiG: At least 1 owner");
        require(ownerCount <= 64, "C98MSiG: Max owner reached");
        _voteRequirement = requirement;

        OwnersChanged(nOwners, requirement.requiredVote, requirement.totalVote);
    }
}

contract C98MSiGFactory {
    event Created(address indexed wallet, address[] owners);

    
    
    
    
    function createMulitSig(address[] memory owners_, uint16[] memory vPowers_, uint16 requiredVote_)
        external returns (C98MSiG wallet) {
        wallet = new C98MSiG(owners_, vPowers_, requiredVote_);
        emit Created(address(wallet), owners_);
    }
}