

pragma solidity ^0.4.24;






library SafeMath {

  


  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    
    
    
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    require(c / _a == _b);
    return c;
  }

  


  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    
    
    
    return _a / _b;
  }

  


  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require(_b <= _a);
    return _a - _b;
  }

  


  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    require(c >= _a);
    return c;
  }
}



pragma solidity ^0.4.24;

contract TwoKeyCongress {

    event ReceivedEther(address sender, uint amount);
    using SafeMath for uint;

    bool initialized;

    
    uint256 maxVotingPower;
    
    uint256 public minimumQuorum;
    
    uint256 public debatingPeriodInMinutes;
    
    Proposal[] public proposals;
    
    uint public numProposals;

    mapping (address => bool) public isMemberInCongress;
    
    mapping(address => Member) public address2Member;
    
    address[] public allMembers;
    
    bytes32[] allowedMethodSignatures;

    mapping(bytes32 => string) methodHashToMethodName;

    event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
    event Voted(uint proposalID, bool position, address voter, string justification);
    event ProposalTallied(uint proposalID, int result, uint quorum, bool active);
    event MembershipChanged(address member, bool isMember);
    event ChangeOfRules(uint256 _newMinimumQuorum, uint256 _newDebatingPeriodInMinutes);

    struct Proposal {
        address recipient;
        uint amount;
        string description;
        uint minExecutionDate;
        bool executed;
        bool proposalPassed;
        uint numberOfVotes;
        int currentResult;
        bytes32 proposalHash;
        bytes transactionBytecode;
        Vote[] votes;
        mapping (address => bool) voted;
    }

    struct Member {
        address memberAddress;
        bytes32 name;
        uint votingPower;
        uint memberSince;
    }

    struct Vote {
        bool inSupport;
        address voter;
        string justification;
    }

    
    modifier onlyMembers {
        require(isMemberInCongress[msg.sender] == true);
        _;
    }

    
    
    
    function onlyAllowedMethods(
        bytes bytecode
    )
    public
    view
    returns (bool)
    {
        for(uint i=0; i< allowedMethodSignatures.length; i++) {
            if(compare(allowedMethodSignatures[i], bytecode)) {
                return true;
            }
        }
        return false;
    }

    






    constructor(
        uint256 _minutesForDebate,
        address[] initialMembers,
        bytes32[] initialMemberNames,
        uint[] votingPowers
    )
    payable
    public
    {
        changeVotingRules(0, _minutesForDebate);
        for(uint i=0; i<initialMembers.length; i++) {
            addMember(initialMembers[i], initialMemberNames[i], votingPowers[i]);
        }
        initialized = true;
        addInitialWhitelistedMethods();
    }


    
    
    function addInitialWhitelistedMethods()
    internal
    {
        hashAllowedMethods("transferByAdmins(address,uint256)");
        hashAllowedMethods("transferEtherByAdmins(address,uint256)");
        hashAllowedMethods("destroy");
        hashAllowedMethods("transfer2KeyTokens(address,uint256)");
        hashAllowedMethods("addMaintainerForRegistry(address)");
        hashAllowedMethods("twoKeyEventSourceAddMaintainer(address[])");
        hashAllowedMethods("twoKeyEventSourceWhitelistContract(address)");
        hashAllowedMethods("freezeTransfersInEconomy");
        hashAllowedMethods("unfreezeTransfersInEconomy");
        hashAllowedMethods("addMaintainersToSelectedSingletone(address,address[])");
        hashAllowedMethods("deleteMaintainersFromSelectedSingletone(address,address[])");
        hashAllowedMethods("updateRewardsRelease(uint256)");
        hashAllowedMethods("updateTwoKeyTokenRate(uint256)");
    }


    
    
    
    
    
    
    function compare(
        bytes32 x,
        bytes y
    )
    public
    pure
    returns (bool)
    {
        for(uint i=0;i<3;i++) {
            byte a = x[i];
            byte b = y[i];
            if(a != b) {
                return false;
            }
        }
        return true;
    }


    
    
    
    
    function hashAllowedMethods(
        string nameAndParams
    )
    internal
    {
        bytes32 allowed = keccak256(abi.encodePacked(nameAndParams));
        allowedMethodSignatures.push(allowed);
        methodHashToMethodName[allowed] = nameAndParams;
    }


    
    
    
    function replaceMemberAddress(
        address _newMemberAddress
    )
    public
    {
        require(_newMemberAddress != address(0));
        
        isMemberInCongress[_newMemberAddress] = true;
        isMemberInCongress[msg.sender] = false;

        
        for(uint i=0; i<allMembers.length; i++) {
            if(allMembers[i] == msg.sender) {
                allMembers[i] = _newMemberAddress;
            }
        }

        
        Member memory m = address2Member[msg.sender];
        address2Member[_newMemberAddress] = m;
        address2Member[msg.sender] = Member(
            {
            memberAddress: address(0),
            memberSince: block.timestamp,
            votingPower: 0,
            name: "0x0"
            }
        );
    }

    
    







    function addMember(
        address targetMember,
        bytes32 memberName,
        uint _votingPower
    )
    public
    {
        if(initialized == true) {
            require(msg.sender == address(this));
        }
        minimumQuorum = allMembers.length;
        maxVotingPower += _votingPower;
        address2Member[targetMember] = Member(
            {
                memberAddress: targetMember,
                memberSince: block.timestamp,
                votingPower: _votingPower,
                name: memberName
            }
        );
        allMembers.push(targetMember);
        isMemberInCongress[targetMember] = true;
        emit MembershipChanged(targetMember, true);
    }

    






    function removeMember(
        address targetMember
    )
    public
    {
        require(msg.sender == address(this));
        require(isMemberInCongress[targetMember] == true);

        
        uint votingPower = getMemberVotingPower(targetMember);
        maxVotingPower-= votingPower;

        uint i=0;
        
        while(allMembers[i] != targetMember) {
            if(i == allMembers.length) {
                revert();
            }
            i++;
        }
        
        for (uint j = i; j< allMembers.length; j++){
            allMembers[j] = allMembers[j+1];
        }
        
        delete allMembers[allMembers.length-1];
        allMembers.length--;

        
        isMemberInCongress[targetMember] = false;

        
        address2Member[targetMember] = Member(
            {
                memberAddress: address(0),
                memberSince: block.timestamp,
                votingPower: 0,
                name: "0x0"
            }
        );
        
        minimumQuorum -= 1;
    }

    





    function addNewAllowedBytecode(
        bytes32 functionSignature
    )
    public
    {
        require(msg.sender == address(this));
        allowedMethodSignatures.push(bytes32(functionSignature));
    }
    








    function changeVotingRules(
        uint256 minimumQuorumForProposals,
        uint256 minutesForDebate
    )
    internal
    {
        minimumQuorum = minimumQuorumForProposals;
        debatingPeriodInMinutes = minutesForDebate;

        emit ChangeOfRules(minimumQuorumForProposals, minutesForDebate);
    }

    









    function newProposal(
        address beneficiary,
        uint weiAmount,
        string jobDescription,
        bytes transactionBytecode)
    public
    onlyMembers
    returns (uint proposalID)
    {
        require(onlyAllowedMethods(transactionBytecode)); 
        proposalID = proposals.length++;
        Proposal storage p = proposals[proposalID];
        p.recipient = beneficiary;
        p.amount = weiAmount;
        p.description = jobDescription;
        p.proposalHash = keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
        p.transactionBytecode = transactionBytecode;
        p.minExecutionDate = block.timestamp + debatingPeriodInMinutes * 1 minutes;
        p.executed = false;
        p.proposalPassed = false;
        p.numberOfVotes = 0;
        p.currentResult = 0;
        emit ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
        numProposals = proposalID+1;

        return proposalID;
    }

    










    function newProposalInEther(
        address beneficiary,
        uint etherAmount,
        string jobDescription,
        bytes transactionBytecode
    )
    public
    onlyMembers
    returns (uint proposalID)
    {
        return newProposal(beneficiary, etherAmount * 1 ether, jobDescription, transactionBytecode);
    }

    







    function checkProposalCode(
        uint proposalNumber,
        address beneficiary,
        uint weiAmount,
        bytes transactionBytecode
    )
    public
    view
    returns (bool codeChecksOut)
    {
        Proposal storage p = proposals[proposalNumber];
        return p.proposalHash == keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
    }

    








    function vote(
        uint proposalNumber,
        bool supportsProposal,
        string justificationText)
    public
    onlyMembers
    returns (uint256 voteID)
    {
        Proposal storage p = proposals[proposalNumber]; 
        require(block.timestamp <= p.minExecutionDate);
        require(!p.voted[msg.sender]);                  
        p.voted[msg.sender] = true;                     
        p.numberOfVotes++;
        voteID = p.numberOfVotes;                     
        p.votes.push(Vote({ inSupport: supportsProposal, voter: msg.sender, justification: justificationText }));
        uint votingPower = getMemberVotingPower(msg.sender);
        if (supportsProposal) {                         
            p.currentResult+= int(votingPower);                          
        } else {                                        
            p.currentResult-= int(votingPower);                          
        }
        
        emit Voted(proposalNumber,  supportsProposal, msg.sender, justificationText);
        return voteID;
    }

    function getVoteCount(
        uint256 proposalNumber
    )
    onlyMembers
    public
    view
    returns(uint256 numberOfVotes, int256 currentResult, string description)
    {
        require(proposals[proposalNumber].proposalHash != 0);
        numberOfVotes = proposals[proposalNumber].numberOfVotes;
        currentResult = proposals[proposalNumber].currentResult;
        description = proposals[proposalNumber].description;
    }

    
    function getMemberInfo()
    public
    view
    returns (address, bytes32, uint, uint)
    {
        Member memory member = address2Member[msg.sender];
        return (member.memberAddress, member.name, member.votingPower, member.memberSince);
    }

    







    function executeProposal(
        uint proposalNumber,
        bytes transactionBytecode
    )
    public
    {
        Proposal storage p = proposals[proposalNumber];

        require(

             !p.executed                                                         
            && p.proposalHash == keccak256(abi.encodePacked(p.recipient, p.amount, transactionBytecode))  
            && p.numberOfVotes >= minimumQuorum.sub(1) 
        
            && uint(p.currentResult) >= maxVotingPower.mul(51).div(100)
            && p.currentResult > 0
        );

        
        p.executed = true; 
        require(p.recipient.call.value(p.amount)(transactionBytecode));
        p.proposalPassed = true;

        
        emit ProposalTallied(proposalNumber, p.currentResult, p.numberOfVotes, p.proposalPassed);
    }


    
    
    
    function getMemberVotingPower(
        address _memberAddress
    )
    public
    view
    returns (uint)
    {
        Member memory _member = address2Member[msg.sender];
        return _member.votingPower;
    }

    
    
    function checkIsMember(
        address _member
    )
    public
    view
    returns (bool)
    {
        return isMemberInCongress[_member];
    }

    
    function () payable public {
        emit ReceivedEther(msg.sender, msg.value);
    }

    
    
    function getMaxVotingPower()
    public
    view
    returns (uint)
    {
        return maxVotingPower;
    }

    
    
    function getMembersLength()
    public
    view
    returns (uint)
    {
        return allMembers.length;
    }

    
    
    function getAllowedMethods()
    public
    view
    returns (bytes32[])
    {
        return allowedMethodSignatures;
    }

    
    
    function getMethodNameFromMethodHash(
        bytes32 _methodHash
    )
    public
    view
    returns(string)
    {
        return methodHashToMethodName[_methodHash];
    }

    
    
    
    function getProposalData(
        uint proposalId
    )
    public
    view
    returns (uint,string,uint,bool,uint,int,bytes)
    {
        Proposal memory p = proposals[proposalId];
        return (p.amount, p.description, p.minExecutionDate, p.executed, p.numberOfVotes, p.currentResult, p.transactionBytecode);
    }

    
    
    function getAllMemberAddresses()
    public
    view
    returns (address[])
    {
        return allMembers;
    }

}