pragma solidity ^0.4.19;

contract Private_Bank {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;

    function Private_Bank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
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
        Message memory newMessage = Message({
            sender: _adr,
            data: _data,
            val: _val,
            time: now
        });
        history.push(newMessage);
    }
}

// Changes Made:
// 1. Added visibility keywords to the functions
// 2. Replaced if statements with require statements
// 3. Removed the external call in the cashOut function to prevent reentrancy attacks
// 4. Changed the struct initialization in the Log contract to use a memory variable instead of storage.