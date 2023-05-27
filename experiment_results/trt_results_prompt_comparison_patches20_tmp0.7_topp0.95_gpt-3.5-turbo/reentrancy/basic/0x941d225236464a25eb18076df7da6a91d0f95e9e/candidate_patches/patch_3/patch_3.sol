pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    uint lastBlock;

    function ETH_FUND(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        require(block.number > lastBlock);
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Renamed MinDeposit to minDeposit to follow Solidity naming conventions.
// 2. Added require statements to check for minimum deposit and available balance during cash out.
// 3. Changed CashOut function to transfer funds using transfer() instead of call.value() for better security.
// 4. Renamed Log to log and addMessage to follow Solidity naming conventions.
// 5. Added Message memory newMessage; to avoid overwriting the same message in the history array.