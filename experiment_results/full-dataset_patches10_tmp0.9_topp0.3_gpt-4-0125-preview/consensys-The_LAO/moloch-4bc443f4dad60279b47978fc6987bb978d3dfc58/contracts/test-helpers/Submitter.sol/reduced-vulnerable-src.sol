

pragma solidity ^0.5.2;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {

        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}



pragma solidity ^0.5.2;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}



pragma solidity ^0.5.0;
















contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        
        
        
        
        
        
        _notEntered = true;
    }

    






    modifier nonReentrant() {
        
        require(_notEntered, "ReentrancyGuard: reentrant call");

        
        _notEntered = false;

        _;

        
        
        _notEntered = true;
    }
}



pragma solidity 0.5.3;

contract GuildBank  {
    address public owner;

    constructor () public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    event Withdrawal(address indexed receiver, address indexed tokenAddress, uint256 amount);

    function withdraw(address receiver, uint256 shares, uint256 totalShares, IERC20[] memory approvedTokens) public onlyOwner returns (bool) {
        for (uint256 i = 0; i < approvedTokens.length; i++) {
            uint256 amount = fairShare(approvedTokens[i].balanceOf(address(this)), shares, totalShares);
            emit Withdrawal(receiver, address(approvedTokens[i]), amount);
            require(approvedTokens[i].transfer(receiver, amount));
        }
        return true;
    }

    function withdrawToken(IERC20 token, address receiver, uint256 amount) public onlyOwner returns (bool) {
        emit Withdrawal(receiver, address(token), amount);
        return token.transfer(receiver, amount);
    }

    function fairShare(uint256 balance, uint256 shares, uint256 totalShares) internal pure returns (uint256) {
        require(totalShares != 0);

        if (balance == 0) { return 0; }

        uint256 prod = balance * shares;

        if (prod / balance == shares) { 
            return prod / totalShares;
        }

        return (balance / totalShares) * shares;
    }

}



pragma solidity 0.5.3;




contract Moloch is ReentrancyGuard {
    using SafeMath for uint256;

    


    address public summoner; 

    uint256 public periodDuration; 
    uint256 public votingPeriodLength; 
    uint256 public gracePeriodLength; 
    uint256 public emergencyProcessingWait; 
    uint256 public bailoutWait; 
    uint256 public proposalDeposit; 
    uint256 public dilutionBound; 
    uint256 public processingReward; 
    uint256 public summoningTime; 

    IERC20 public depositToken; 
    GuildBank public guildBank; 

    
    
    
    uint256 constant MAX_VOTING_PERIOD_LENGTH = 10**18; 
    uint256 constant MAX_GRACE_PERIOD_LENGTH = 10**18; 
    uint256 constant MAX_BAILOUT_WAIT = 10**18; 
    uint256 constant MAX_DILUTION_BOUND = 10**18; 
    uint256 constant MAX_NUMBER_OF_SHARES_AND_LOOT = 10**18; 

    
    
    
    event SubmitProposal(uint256 proposalIndex, address indexed delegateKey, address indexed memberAddress, address indexed applicant, uint256 sharesRequested, uint256 lootRequested, uint256 tributeOffered, address tributeToken, uint256 paymentRequested, address paymentToken);
    event SponsorProposal(address indexed delegateKey, address indexed memberAddress, uint256 proposalIndex, uint256 proposalQueueIndex, uint256 startingPeriod);
    event SubmitVote(uint256 indexed proposalIndex, address indexed delegateKey, address indexed memberAddress, uint8 uintVote);
    event ProcessProposal(uint256 indexed proposalIndex, uint256 indexed proposalId, bool didPass);
    event Ragequit(address indexed memberAddress, uint256 sharesToBurn, uint256 lootToBurn);
    event CancelProposal(uint256 indexed proposalIndex, address applicantAddress);
    event UpdateDelegateKey(address indexed memberAddress, address newDelegateKey);
    event SummonComplete(address indexed summoner, uint256 shares);

    
    
    
    uint256 public proposalCount = 0; 
    uint256 public totalShares = 0; 
    uint256 public totalLoot = 0; 

    bool public emergencyWarning = false; 
    uint256 public lastEmergencyProposalIndex = 0; 

    enum Vote {
        Null, 
        Yes,
        No
    }

    struct Member {
        address delegateKey; 
        uint256 shares; 
        uint256 loot; 
        bool exists; 
        uint256 highestIndexYesVote; 
        uint256 jailed; 
    }

    struct Proposal {
        address applicant; 
        address proposer; 
        address sponsor; 
        uint256 sharesRequested; 
        uint256 lootRequested; 
        uint256 tributeOffered; 
        IERC20 tributeToken; 
        uint256 paymentRequested; 
        IERC20 paymentToken; 
        uint256 startingPeriod; 
        uint256 yesVotes; 
        uint256 noVotes; 
        bool[6] flags; 
        string details; 
        uint256 maxTotalSharesAndLootAtYesVote; 
        mapping(address => Vote) votesByMember; 
    }

    mapping(address => bool) public tokenWhitelist;
    IERC20[] public approvedTokens;

    mapping(address => bool) public proposedToWhitelist;
    mapping(address => bool) public proposedToKick;

    mapping(address => Member) public members;
    mapping(address => address) public memberAddressByDelegateKey;

    mapping(uint256 => Proposal) public proposals;

    uint256[] public proposalQueue;

    modifier onlyMember {
        require(members[msg.sender].shares > 0 || members[msg.sender].loot > 0, "not a member");
        _;
    }

    modifier onlyShareholder {
        require(members[msg.sender].shares > 0, "not a shareholder");
        _;
    }

    modifier onlyDelegate {
        require(members[memberAddressByDelegateKey[msg.sender]].shares > 0, "not a delegate");
        _;
    }

    constructor(
        address _summoner,
        address[] memory _approvedTokens,
        uint256 _periodDuration,
        uint256 _votingPeriodLength,
        uint256 _gracePeriodLength,
        uint256 _emergencyProcessingWait,
        uint256 _bailoutWait,
        uint256 _proposalDeposit,
        uint256 _dilutionBound,
        uint256 _processingReward
    ) public {
        require(_summoner != address(0), "summoner cannot be 0");
        require(_periodDuration > 0, "_periodDuration cannot be 0");
        require(_votingPeriodLength > 0, "_votingPeriodLength cannot be 0");
        require(_votingPeriodLength <= MAX_VOTING_PERIOD_LENGTH, "_votingPeriodLength exceeds limit");
        require(_gracePeriodLength <= MAX_GRACE_PERIOD_LENGTH, "_gracePeriodLength exceeds limit");
        require(_emergencyProcessingWait > 0, "_emergencyProcessingWait cannot be 0");
        require(_bailoutWait > _emergencyProcessingWait, "_bailoutWait must be greater than _emergencyProcessingWait");
        require(_bailoutWait <= MAX_BAILOUT_WAIT, "_bailoutWait exceeds limit");
        require(_dilutionBound > 0, "_dilutionBound cannot be 0");
        require(_dilutionBound <= MAX_DILUTION_BOUND, "_dilutionBound exceeds limit");
        require(_approvedTokens.length > 0, "need at least one approved token");
        require(_proposalDeposit >= _processingReward, "_proposalDeposit cannot be smaller than _processingReward");

        summoner = _summoner;

        depositToken = IERC20(_approvedTokens[0]);

        for (uint256 i = 0; i < _approvedTokens.length; i++) {
            require(_approvedTokens[i] != address(0), "_approvedToken cannot be 0");
            require(!tokenWhitelist[_approvedTokens[i]], "duplicate approved token");
            tokenWhitelist[_approvedTokens[i]] = true;
            approvedTokens.push(IERC20(_approvedTokens[i]));
        }

        guildBank = new GuildBank();

        periodDuration = _periodDuration;
        votingPeriodLength = _votingPeriodLength;
        gracePeriodLength = _gracePeriodLength;
        emergencyProcessingWait = _emergencyProcessingWait;
        bailoutWait = _bailoutWait;
        proposalDeposit = _proposalDeposit;
        dilutionBound = _dilutionBound;
        processingReward = _processingReward;

        summoningTime = now;

        members[summoner] = Member(summoner, 1, 0, true, 0, 0);
        memberAddressByDelegateKey[summoner] = summoner;
        totalShares = 1;

        emit SummonComplete(summoner, 1);
    }

    


    function submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        string memory details
    ) public nonReentrant returns (uint256 proposalId) {
        require(sharesRequested.add(lootRequested) <= MAX_NUMBER_OF_SHARES_AND_LOOT, "too many shares requested");
        require(tokenWhitelist[tributeToken], "tributeToken is not whitelisted");
        require(tokenWhitelist[paymentToken], "payment is not whitelisted");
        require(applicant != address(0), "applicant cannot be 0");
        require(members[applicant].jailed == 0, "proposal applicant must not be jailed");

        
        require(IERC20(tributeToken).transferFrom(msg.sender, address(this), tributeOffered), "tribute token transfer failed");

        bool[6] memory flags;

        _submitProposal(applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken, details, flags);
        return proposalCount - 1; 
    }

    function submitWhitelistProposal(address tokenToWhitelist, string memory details) public nonReentrant returns (uint256 proposalId) {
        require(tokenToWhitelist != address(0), "must provide token address");
        require(!tokenWhitelist[tokenToWhitelist], "cannot already have whitelisted the token");

        bool[6] memory flags;
        flags[4] = true;

        _submitProposal(address(0), 0, 0, 0, tokenToWhitelist, 0, address(0), details, flags);
        return proposalCount - 1;
    }

    function submitGuildKickProposal(address memberToKick, string memory details) public nonReentrant returns (uint256 proposalId) {
        Member memory member = members[memberToKick];

        require(member.shares > 0 || member.loot > 0, "member must have at least one share or one loot");
        require(memberToKick != summoner, "the summoner may not be kicked");
        require(members[memberToKick].jailed == 0, "member must not already be jailed");

        bool[6] memory flags;
        flags[5] = true;

        _submitProposal(memberToKick, 0, 0, 0, address(0), 0, address(0), details, flags);
        return proposalCount - 1;
    }

    function _submitProposal(
        address applicant,
        uint256 sharesRequested,
        uint256 lootRequested,
        uint256 tributeOffered,
        address tributeToken,
        uint256 paymentRequested,
        address paymentToken,
        string memory details,
        bool[6] memory flags
    ) internal {
        Proposal memory proposal = Proposal({
            applicant : applicant,
            proposer : msg.sender,
            sponsor : address(0),
            sharesRequested : sharesRequested,
            lootRequested : lootRequested,
            tributeOffered : tributeOffered,
            tributeToken : IERC20(tributeToken),
            paymentRequested : paymentRequested,
            paymentToken : IERC20(paymentToken),
            startingPeriod : 0,
            yesVotes : 0,
            noVotes : 0,
            flags : flags,
            details : details,
            maxTotalSharesAndLootAtYesVote : 0
        });

        proposals[proposalCount] = proposal;
        address memberAddress = memberAddressByDelegateKey[msg.sender];
        emit SubmitProposal(proposalCount, msg.sender, memberAddress, applicant, sharesRequested, lootRequested, tributeOffered, tributeToken, paymentRequested, paymentToken);
        proposalCount += 1;
    }
    
    function sponsorProposal(uint256 proposalId) public nonReentrant onlyDelegate {
        
        require(depositToken.transferFrom(msg.sender, address(this), proposalDeposit), "proposal deposit token transfer failed");

        Proposal storage proposal = proposals[proposalId];

        require(proposal.proposer != address(0), 'proposal must have been proposed');
        require(!proposal.flags[0], "proposal has already been sponsored");
        require(!proposal.flags[3], "proposal has been cancelled");
        require(members[proposal.applicant].jailed == 0, "proposal applicant must not be jailed");

        
        if (proposal.flags[4]) {
            require(!tokenWhitelist[address(proposal.tributeToken)], "cannot already have whitelisted the token");
            require(!proposedToWhitelist[address(proposal.tributeToken)], 'already proposed to whitelist');
            proposedToWhitelist[address(proposal.tributeToken)] = true;

        
        } else if (proposal.flags[5]) {
            require(!proposedToKick[proposal.applicant], 'already proposed to kick');
            proposedToKick[proposal.applicant] = true;
        }

        
        uint256 startingPeriod = max(
            getCurrentPeriod(),
            proposalQueue.length == 0 ? 0 : proposals[proposalQueue[proposalQueue.length.sub(1)]].startingPeriod
        ).add(1);

        proposal.startingPeriod = startingPeriod;

        address memberAddress = memberAddressByDelegateKey[msg.sender];
        proposal.sponsor = memberAddress;

        proposal.flags[0] = true;

        
        proposalQueue.push(proposalId);
        emit SponsorProposal(msg.sender, memberAddress, proposalId, proposalQueue.length.sub(1), startingPeriod);
    }

    function submitVote(uint256 proposalIndex, uint8 uintVote) public nonReentrant onlyDelegate {
        address memberAddress = memberAddressByDelegateKey[msg.sender];
        Member storage member = members[memberAddress];

        require(proposalIndex < proposalQueue.length, "proposal does not exist");
        Proposal storage proposal = proposals[proposalQueue[proposalIndex]];

        require(uintVote < 3, "must be less than 3");
        Vote vote = Vote(uintVote);

        require(getCurrentPeriod() >= proposal.startingPeriod, "voting period has not started");
        require(!hasVotingPeriodExpired(proposal.startingPeriod), "proposal voting period has expired");
        require(proposal.votesByMember[memberAddress] == Vote.Null, "member has already voted");
        require(vote == Vote.Yes || vote == Vote.No, "vote must be either Yes or No");

        proposal.votesByMember[memberAddress] = vote;

        if (vote == Vote.Yes) {
            proposal.yesVotes = proposal.yesVotes.add(member.shares);

            
            if (proposalIndex > member.highestIndexYesVote) {
                member.highestIndexYesVote = proposalIndex;
            }

            
            if (totalShares.add(totalLoot) > proposal.maxTotalSharesAndLootAtYesVote) {
                proposal.maxTotalSharesAndLootAtYesVote = totalShares.add(totalLoot);
            }

        } else if (vote == Vote.No) {
            proposal.noVotes = proposal.noVotes.add(member.shares);
        }

        emit SubmitVote(proposalIndex, msg.sender, memberAddress, uintVote);
    }

    function processProposal(uint256 proposalIndex) public nonReentrant {
        _validateProposalForProcessing(proposalIndex);

        uint256 proposalId = proposalQueue[proposalIndex];
        Proposal storage proposal = proposals[proposalId];

        require(!proposal.flags[4] && !proposal.flags[5], "must be a standard proposal");

        proposal.flags[1] = true; 

        (bool didPass, bool emergencyProcessing) = _didPass(proposalIndex);

        
        if (totalShares.add(totalLoot).add(proposal.sharesRequested).add(proposal.lootRequested) > MAX_NUMBER_OF_SHARES_AND_LOOT) {
            didPass = false;
        }

        
        if (!emergencyProcessing && proposal.paymentToken != IERC20(0) && proposal.paymentRequested > proposal.paymentToken.balanceOf(address(guildBank))) {
            didPass = false;
        }

        
        if (didPass) {
            proposal.flags[2] = true; 

            
            if (members[proposal.applicant].exists) {
                members[proposal.applicant].shares = members[proposal.applicant].shares.add(proposal.sharesRequested);
                members[proposal.applicant].loot = members[proposal.applicant].loot.add(proposal.lootRequested);

            
            } else {
                
                if (members[memberAddressByDelegateKey[proposal.applicant]].exists) {
                    address memberToOverride = memberAddressByDelegateKey[proposal.applicant];
                    memberAddressByDelegateKey[memberToOverride] = memberToOverride;
                    members[memberToOverride].delegateKey = memberToOverride;
                }

                
                members[proposal.applicant] = Member(proposal.applicant, proposal.sharesRequested, proposal.lootRequested, true, 0, 0);
                memberAddressByDelegateKey[proposal.applicant] = proposal.applicant;
            }

            
            totalShares = totalShares.add(proposal.sharesRequested);
            totalLoot = totalLoot.add(proposal.lootRequested);

            require(
                proposal.tributeToken.transfer(address(guildBank), proposal.tributeOffered),
                "token transfer to guild bank failed"
            );

            require(
                guildBank.withdrawToken(proposal.paymentToken, proposal.applicant, proposal.paymentRequested),
                "token payment to applicant failed"
            );


        
        } else {
            
            
            if (!emergencyProcessing) {
                require(
                    proposal.tributeToken.transfer(proposal.proposer, proposal.tributeOffered),
                    "failing vote token transfer failed"
                );
            }
        }

        _returnDeposit(proposal.sponsor);

        emit ProcessProposal(proposalIndex, proposalId, didPass);
    }

    function processWhitelistProposal(uint256 proposalIndex) public nonReentrant {
        _validateProposalForProcessing(proposalIndex);

        uint256 proposalId = proposalQueue[proposalIndex];
        Proposal storage proposal = proposals[proposalId];

        require(proposal.flags[4], "must be a whitelist proposal");

        proposal.flags[1] = true; 

        (bool didPass,) = _didPass(proposalIndex);

        if (didPass) {
            proposal.flags[2] = true; 

            tokenWhitelist[address(proposal.tributeToken)] = true;
            approvedTokens.push(proposal.tributeToken);
        }

        proposedToWhitelist[address(proposal.tributeToken)] = false;

        _returnDeposit(proposal.sponsor);

        emit ProcessProposal(proposalIndex, proposalId, didPass);
    }

    function processGuildKickProposal(uint256 proposalIndex) public nonReentrant {
        _validateProposalForProcessing(proposalIndex);

        uint256 proposalId = proposalQueue[proposalIndex];
        Proposal storage proposal = proposals[proposalId];

        require(proposal.flags[5], "must be a guild kick proposal");

        proposal.flags[1] = true; 

        (bool didPass,) = _didPass(proposalIndex);

        if (didPass) {
            proposal.flags[2] = true; 
            Member storage member = members[proposal.applicant];
            member.jailed = proposalIndex;

            
            member.loot = member.loot.add(member.shares);
            totalShares = totalShares.sub(member.shares);
            totalLoot = totalLoot.add(member.shares);
            member.shares = 0; 
        }

        proposedToKick[proposal.applicant] = false;

        _returnDeposit(proposal.sponsor);

        emit ProcessProposal(proposalIndex, proposalId, didPass);
    }

    function _didPass(uint256 proposalIndex) internal returns (bool didPass, bool emergencyProcessing) {
        Proposal memory proposal = proposals[proposalQueue[proposalIndex]];

        didPass = proposal.yesVotes > proposal.noVotes;

        
        emergencyProcessing = false;
        if (getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength).add(emergencyProcessingWait)) {
            emergencyWarning = true;
            lastEmergencyProposalIndex = proposalIndex;
            emergencyProcessing = true;
            didPass = false;
        }

        
        if (emergencyWarning) {
            if (proposal.startingPeriod < proposals[proposalQueue[lastEmergencyProposalIndex]].startingPeriod.add(emergencyProcessingWait)) {
                didPass = false;
            }
        }

        
        if ((totalShares.add(totalLoot)).mul(dilutionBound) < proposal.maxTotalSharesAndLootAtYesVote) {
            didPass = false;
        }

        
        
        
        if (members[proposal.applicant].jailed != 0) {
            didPass = false;
        }

        return (didPass, emergencyProcessing);
    }

    function _validateProposalForProcessing(uint256 proposalIndex) internal view {
        require(proposalIndex < proposalQueue.length, "proposal does not exist");
        Proposal memory proposal = proposals[proposalQueue[proposalIndex]];

        require(getCurrentPeriod() >= proposal.startingPeriod.add(votingPeriodLength).add(gracePeriodLength), "proposal is not ready to be processed");
        require(proposal.flags[1] == false, "proposal has already been processed");
        require(proposalIndex == 0 || proposals[proposalQueue[proposalIndex.sub(1)]].flags[1], "previous proposal must be processed");
    }

    function _returnDeposit(address sponsor) internal {
        require(
            depositToken.transfer(msg.sender, processingReward),
            "failed to send processing reward to msg.sender"
        );

        require(
            depositToken.transfer(sponsor, proposalDeposit.sub(processingReward)),
            "failed to return proposal deposit to sponsor"
        );
    }

    function ragequit(uint256 sharesToBurn, uint256 lootToBurn) public nonReentrant onlyMember {
        _ragequit(msg.sender, sharesToBurn, lootToBurn, approvedTokens);
    }

    function safeRagequit(uint256 sharesToBurn, uint256 lootToBurn, IERC20[] memory tokenList) public nonReentrant onlyMember {
        
        for (uint256 i=0; i < tokenList.length; i++) {
            require(tokenWhitelist[address(tokenList[i])], "token must be whitelisted");

            if (i > 0) {
                require(tokenList[i] > tokenList[i - 1], "token list must be unique and in ascending order");
            }
        }

        _ragequit(msg.sender, sharesToBurn, lootToBurn, tokenList);
    }

    function _ragequit(address memberAddress, uint256 sharesToBurn, uint256 lootToBurn, IERC20[] memory tokenList) internal {
        uint256 initialTotalSharesAndLoot = totalShares.add(totalLoot);

        Member storage member = members[memberAddress];

        require(member.shares >= sharesToBurn, "insufficient shares");
        require(member.loot >= lootToBurn, "insufficient loot");

        require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");

        uint256 sharesAndLootToBurn = sharesToBurn.add(lootToBurn);

        
        member.shares = member.shares.sub(sharesToBurn);
        member.loot = member.loot.sub(lootToBurn);
        totalShares = totalShares.sub(sharesToBurn);
        totalLoot = totalLoot.sub(lootToBurn);

        
        require(
            guildBank.withdraw(memberAddress, sharesAndLootToBurn, initialTotalSharesAndLoot, tokenList),
            "withdrawal of tokens from guildBank failed"
        );

        emit Ragequit(msg.sender, sharesToBurn, lootToBurn);
    }

    function ragekick(address memberToKick) public nonReentrant {
        Member storage member = members[memberToKick];

        require(member.jailed != 0, "member must be in jail");
        require(member.loot > 0, "member must have some loot"); 
        require(canRagequit(member.highestIndexYesVote), "cannot ragequit until highest index proposal member voted YES on is processed");
        require(!canBailout(memberToKick), "bailoutWait has passed, member must be bailed out");

        _ragequit(memberToKick, 0, member.loot, approvedTokens);
    }

    function bailout(address memberToBail) public nonReentrant {
        Member storage member = members[memberToBail];

        require(member.jailed != 0, "member must be in jail");
        require(member.loot > 0, "member must have some loot"); 
        require(canBailout(memberToBail), "cannot bailout yet");

        members[summoner].loot = members[summoner].loot.add(member.loot);
        member.loot = 0;
    }

    function cancelProposal(uint256 proposalId) public nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.flags[0], "proposal has already been sponsored");
        require(!proposal.flags[3], "proposal has already been cancelled");
        require(msg.sender == proposal.proposer, "solely the proposer can cancel");

        proposal.flags[3] = true; 

        require(
            proposal.tributeToken.transfer(proposal.proposer, proposal.tributeOffered),
            "failed to return tribute to proposer"
        );

        emit CancelProposal(proposalId, msg.sender);
    }

    function updateDelegateKey(address newDelegateKey) public nonReentrant onlyShareholder {
        require(newDelegateKey != address(0), "newDelegateKey cannot be 0");

        
        if (newDelegateKey != msg.sender) {
            require(!members[newDelegateKey].exists, "cannot overwrite existing members");
            require(!members[memberAddressByDelegateKey[newDelegateKey]].exists, "cannot overwrite existing delegate keys");
        }

        Member storage member = members[msg.sender];
        memberAddressByDelegateKey[member.delegateKey] = address(0);
        memberAddressByDelegateKey[newDelegateKey] = msg.sender;
        member.delegateKey = newDelegateKey;

        emit UpdateDelegateKey(msg.sender, newDelegateKey);
    }

    


    
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x : y;
    }

    function getCurrentPeriod() public view returns (uint256) {
        return now.sub(summoningTime).div(periodDuration);
    }

    function getProposalQueueLength() public view returns (uint256) {
        return proposalQueue.length;
    }

    function getProposalFlags(uint256 proposalId) public view returns (bool[6] memory) {
        return proposals[proposalId].flags;
    }

    
    function canRagequit(uint256 highestIndexYesVote) public view returns (bool) {
        require(highestIndexYesVote < proposalQueue.length, "proposal does not exist");
        return proposals[proposalQueue[highestIndexYesVote]].flags[1];
    }

    function canBailout(address memberToBail) public view returns (bool) {
        Member memory member = members[memberToBail];

        
        
        uint256 bailoutWaitStartingPeriod = member.highestIndexYesVote > member.jailed
            ? proposals[proposalQueue[member.highestIndexYesVote]].startingPeriod
            : proposals[proposalQueue[member.jailed]].startingPeriod;

        
        return getCurrentPeriod() >= bailoutWaitStartingPeriod.add(votingPeriodLength).add(gracePeriodLength).add(bailoutWait);
    }

    function hasVotingPeriodExpired(uint256 startingPeriod) public view returns (bool) {
        return getCurrentPeriod() >= startingPeriod.add(votingPeriodLength);
    }

    function getMemberProposalVote(address memberAddress, uint256 proposalIndex) public view returns (Vote) {
        require(members[memberAddress].exists, "member does not exist");
        require(proposalIndex < proposalQueue.length, "proposal does not exist");
        return proposals[proposalQueue[proposalIndex]].votesByMember[memberAddress];
    }
}





pragma solidity 0.5.3;

contract Submitter {

  event Submit(uint256 proposalId);

  Moloch public moloch; 

  constructor(address molochAddress) public {
    moloch = Moloch(molochAddress);
  }

  function submitProposal(
    address applicant,
    uint256 sharesRequested,
    uint256 lootRequested,
    uint256 tributeOffered,
    address tributeToken,
    uint256 paymentRequested,
    address paymentToken,
    string memory details
  ) public {
    uint256 proposalId = moloch.submitProposal(
      applicant,
      sharesRequested,
      lootRequested,
      tributeOffered,
      tributeToken,
      paymentRequested,
      paymentToken,
      details
    );

    emit Submit(proposalId);
  }

  function submitWhitelistProposal(
    address tokenToWhitelist,
    string memory details
  ) public {
    uint256 proposalId = moloch.submitWhitelistProposal(
      tokenToWhitelist,
      details
    );

    emit Submit(proposalId);
  }

  function submitGuildKickProposal(
    address memberToKick,
    string memory details
  ) public {
    uint256 proposalId = moloch.submitGuildKickProposal(
      memberToKick,
      details
    );

    emit Submit(proposalId);
  }
}