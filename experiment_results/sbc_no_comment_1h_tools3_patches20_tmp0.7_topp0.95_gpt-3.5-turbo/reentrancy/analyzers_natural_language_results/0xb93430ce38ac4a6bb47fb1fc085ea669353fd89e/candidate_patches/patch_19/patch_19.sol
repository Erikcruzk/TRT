pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public {
        TransferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
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
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        history.push(newMessage);
    }
}

// Changes Made:
// 1. Made the constructor function public
// 2. Used require statement to check the condition instead of if statement
// 3. Used transfer function to prevent reentrancy attack
// 4. Changed function names to follow Solidity conventions (camelCase)
// 5. Changed variable names to follow Solidity conventions (camelCase)
// 6. Used memory to create new struct instances to avoid overwriting the same struct instance in the array.