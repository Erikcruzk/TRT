pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
        Message memory newMsg;
        newMsg.sender = _adr;
        newMsg.time = now;
        newMsg.val = _val;
        newMsg.data = _data;
        history.push(newMsg);
    }
} 

// Changes made:
// 1. Changed function names to follow Solidity naming conventions (lowercase first letter)
// 2. Added require statement to check for sufficient balance before cashing out
// 3. Changed the transfer function to use transfer() instead of call.value()
// 4. Changed struct member names to lowercase
// 5. Modified the addMessage() function to create a new Message struct instead of modifying the LastMsg struct, and store it in the History array.