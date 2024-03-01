

pragma solidity ^0.4.21;





contract SafeMath {
    


    function SafeMath() public {
    }

    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(a >= b);
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}



pragma solidity ^0.4.21;






contract IERC20Token {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value)  public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
    function approve(address _spender, uint256 _value)  public returns (bool success);
    function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}



pragma solidity ^0.4.21;






contract BasePoll is SafeMath {
    struct Vote {
        uint256 time;
        uint256 weight;
        bool agree;
    }

    uint256 public constant MAX_TOKENS_WEIGHT_DENOM = 1000;

    IERC20Token public token;
    address public fundAddress;

    uint256 public startTime;
    uint256 public endTime;
    bool checkTransfersAfterEnd;

    uint256 public yesCounter = 0;
    uint256 public noCounter = 0;
    uint256 public totalVoted = 0;

    bool public finalized;
    mapping(address => Vote) public votesByAddress;

    modifier checkTime() {
        require(now >= startTime && now <= endTime);
        _;
    }

    modifier notFinalized() {
        require(!finalized);
        _;
    }

    






    function BasePoll(address _tokenAddress, address _fundAddress, uint256 _startTime, uint256 _endTime, bool _checkTransfersAfterEnd) public {
        require(_tokenAddress != address(0));
        require(_startTime >= now && _endTime > _startTime);

        token = IERC20Token(_tokenAddress);
        fundAddress = _fundAddress;
        startTime = _startTime;
        endTime = _endTime;
        finalized = false;
        checkTransfersAfterEnd = _checkTransfersAfterEnd;
    }

    



    function vote(bool agree) public checkTime {
        require(votesByAddress[msg.sender].time == 0);

        uint256 voiceWeight = token.balanceOf(msg.sender);
        uint256 maxVoiceWeight = safeDiv(token.totalSupply(), MAX_TOKENS_WEIGHT_DENOM);
        voiceWeight =  voiceWeight <= maxVoiceWeight ? voiceWeight : maxVoiceWeight;

        if(agree) {
            yesCounter = safeAdd(yesCounter, voiceWeight);
        } else {
            noCounter = safeAdd(noCounter, voiceWeight);

        }

        votesByAddress[msg.sender].time = now;
        votesByAddress[msg.sender].weight = voiceWeight;
        votesByAddress[msg.sender].agree = agree;

        totalVoted = safeAdd(totalVoted, 1);
    }

    


    function revokeVote() public checkTime {
        require(votesByAddress[msg.sender].time > 0);

        uint256 voiceWeight = votesByAddress[msg.sender].weight;
        bool agree = votesByAddress[msg.sender].agree;

        votesByAddress[msg.sender].time = 0;
        votesByAddress[msg.sender].weight = 0;
        votesByAddress[msg.sender].agree = false;

        totalVoted = safeSub(totalVoted, 1);
        if(agree) {
            yesCounter = safeSub(yesCounter, voiceWeight);
        } else {
            noCounter = safeSub(noCounter, voiceWeight);
        }
    }

    



    function onTokenTransfer(address tokenHolder, uint256 amount) public {
        require(msg.sender == fundAddress);
        if(votesByAddress[tokenHolder].time == 0) {
            return;
        }
        if(!checkTransfersAfterEnd) {
             if(finalized || (now < startTime || now > endTime)) {
                 return;
             }
        }

        if(token.balanceOf(tokenHolder) >= votesByAddress[tokenHolder].weight) {
            return;
        }
        uint256 voiceWeight = amount;
        if(amount > votesByAddress[tokenHolder].weight) {
            voiceWeight = votesByAddress[tokenHolder].weight;
        }

        if(votesByAddress[tokenHolder].agree) {
            yesCounter = safeSub(yesCounter, voiceWeight);
        } else {
            noCounter = safeSub(noCounter, voiceWeight);
        }
        votesByAddress[tokenHolder].weight = safeSub(votesByAddress[tokenHolder].weight, voiceWeight);
    }

    


    function tryToFinalize() public notFinalized returns(bool) {
        if(now < endTime) {
            return false;
        }
        finalized = true;
        onPollFinish(isSubjectApproved());
        return true;
    }

    function isNowApproved() public view returns(bool) {
        return isSubjectApproved();
    }

    function isSubjectApproved() internal view returns(bool) {
        return yesCounter > noCounter;
    }

    


    function onPollFinish(bool agree) internal;
}



pragma solidity ^0.4.21;





interface IPollManagedFund {
    




    function onTapPollFinish(bool agree, uint256 _tap) external;

    



    function onRefundPollFinish(bool agree) external;
}



pragma solidity ^0.4.21;






contract RefundPoll is BasePoll {
    uint256 public holdEndTime = 0;

    






    function RefundPoll(
        address _tokenAddress,
        address _fundAddress,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _holdEndTime,
        bool _checkTransfersAfterEnd
    ) public
        BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, _checkTransfersAfterEnd)
    {
        holdEndTime = _holdEndTime;
    }

    function tryToFinalize() public returns(bool) {
        if(holdEndTime > 0 && holdEndTime > endTime) {
            require(now >= holdEndTime);
        } else {
            require(now >= endTime);
        }

        finalized = true;
        onPollFinish(isSubjectApproved());
        return true;
    }

    function isSubjectApproved() internal view returns(bool) {
        return yesCounter > noCounter && yesCounter >= safeDiv(token.totalSupply(), 3);
    }

    function onPollFinish(bool agree) internal {
        IPollManagedFund fund = IPollManagedFund(fundAddress);
        fund.onRefundPollFinish(agree);
    }

}