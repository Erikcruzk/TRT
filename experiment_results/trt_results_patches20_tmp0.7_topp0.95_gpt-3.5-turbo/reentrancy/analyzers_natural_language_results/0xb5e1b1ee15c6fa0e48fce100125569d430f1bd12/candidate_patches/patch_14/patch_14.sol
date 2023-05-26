pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes Made:
// 1. Made the constructor public
// 2. Replaced if statement with require in deposit function to prevent unnecessary gas usage
// 3. Removed payable keyword from cashOut function as it is not required
// 4. Used transfer function instead of call.value to prevent reentrancy issues
// 5. Changed function and variable names to follow Solidity naming conventions
// 6. Changed struct and variable names to follow Solidity naming conventions
// 7. Changed push statement to use struct with named parameters to improve readability