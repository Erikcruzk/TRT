pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _amount) public {
        require(_amount <= balances[msg.sender]);
        require(msg.sender.call.value(_amount)());
        balances[msg.sender] -= _amount;
        TransferLog.addMessage(msg.sender, _amount, "CashOut");
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

    function addMessage(address _address, uint _value, string _data) public {
        Message memory newMessage = Message({
            sender: _address,
            data: _data,
            val: _value,
            time: now
        });
        history.push(newMessage);
    }
} 

// Changes made:
// 1. Changed function names to follow Solidity naming conventions.
// 2. Added require statements to ensure conditions are met before proceeding.
// 3. Changed variable names to follow Solidity naming conventions.
// 4. Changed the way messages are added to the history array to avoid errors caused by modifying struct properties after they have been added to the array.