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
        Message memory newMessage = Message(_adr, _data, _val, now);
        history.push(newMessage);
    }
}

// The contract has been repaired by:
// 1. Adding the "public" keyword to the constructor function.
// 2. Changing function names to follow the Solidity style guide.
// 3. Using the "require" statement instead of an "if" statement in the deposit function.
// 4. Removing the "if (msg.sender.call.value(_am)())" statement from the cashOut function to prevent reentrancy attacks.
// 5. Using the "transfer" function instead of "call.value" in the cashOut function to prevent reentrancy attacks.
// 6. Changing the variable names to follow the Solidity style guide.