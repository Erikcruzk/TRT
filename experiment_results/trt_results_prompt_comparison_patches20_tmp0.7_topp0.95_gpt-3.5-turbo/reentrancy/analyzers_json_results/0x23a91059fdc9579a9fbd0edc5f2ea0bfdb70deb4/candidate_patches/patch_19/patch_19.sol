pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am > 0 && _am <= balances[msg.sender]);
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
// 1. Added visibility modifier to the constructor and renamed it to match the contract name.
// 2. Added require statement to the deposit function to check if the deposit amount is greater than or equal to MinDeposit.
// 3. Changed the function name 'CashOut' to 'cashOut' and added a require statement to check if the withdrawal amount is greater than 0 and less than or equal to the user's balance.
// 4. Changed the transfer function from call to transfer to prevent reentrancy vulnerability.
// 5. Changed the struct variable names to follow the Solidity naming convention. 
// 6. In the addMessage function, created a new struct variable instead of modifying the previous LastMsg variable to avoid overwriting previous messages in the history array.