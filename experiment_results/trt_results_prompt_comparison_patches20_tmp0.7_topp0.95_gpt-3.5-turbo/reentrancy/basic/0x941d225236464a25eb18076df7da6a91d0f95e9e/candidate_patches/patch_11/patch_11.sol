pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) { // changed to greater than or equal to
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // changed function name to lowercase
            lastBlock = block.number;
        }
    }

    function cashOut(uint _am) public { // removed payable keyword from this function
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            if (msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
                TransferLog.addMessage(msg.sender, _am, "CashOut"); // changed function name to lowercase
            }
        }
    }

    function() public payable {}

    // added function to update min deposit amount
    function updateMinDeposit(uint _newMinDeposit) public {
        MinDeposit = _newMinDeposit;
    }
}

contract Log {
    struct Message {
        address sender; // changed variable name to lowercase
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    Message lastMsg;

    function addMessage(address _adr, uint _val, string _data) public { // changed function name to lowercase
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}