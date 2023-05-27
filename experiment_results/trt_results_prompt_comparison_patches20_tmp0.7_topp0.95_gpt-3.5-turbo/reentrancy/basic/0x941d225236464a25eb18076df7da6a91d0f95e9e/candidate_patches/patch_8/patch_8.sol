pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
        lastBlock = block.number;
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint _am) public {
        require(_am > 0 && _am <= balances[msg.sender] && block.number > lastBlock);
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

//Changes Made
//1. Changed function names to lowercase for consistency.
//2. Added "require" statements to validate inputs.
//3. Changed the function signature of CashOut and added a transfer statement.
//4. Initialized lastBlock in the constructor.
//5. Changed the struct variable names to lowercase for consistency.