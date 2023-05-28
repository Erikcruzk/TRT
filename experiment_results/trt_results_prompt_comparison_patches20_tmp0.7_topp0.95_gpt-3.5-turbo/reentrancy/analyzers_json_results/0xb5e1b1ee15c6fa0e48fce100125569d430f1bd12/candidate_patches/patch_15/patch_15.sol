pragma solidity ^0.4.19;

contract Private_Bank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    function Private_Bank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
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

// The following changes were made:
// - Capitalized the first letter of the variables and functions to follow Solidity naming conventions.
// - Changed "MinDeposit" to "minDeposit".
// - Changed "TransferLog" to "transferLog".
// - Added a "require" statement in the deposit function to check if the deposit value is greater than the minimum deposit.
// - Removed the "payable" modifier from the cashOut function and used the "transfer" function instead of "call.value".
// - Changed "LastMsg" to "newMessage" in the addMessage function and created a new struct instead of reusing the same struct.