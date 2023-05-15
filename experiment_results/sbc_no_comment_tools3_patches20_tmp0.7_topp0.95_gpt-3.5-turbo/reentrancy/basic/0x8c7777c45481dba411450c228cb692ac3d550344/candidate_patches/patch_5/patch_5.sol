pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log public TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _amount) public {
        require(_amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        require(msg.sender.call.value(_amount)());
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
// 1. Changed function names to follow Solidity naming conventions
// 2. Added require statements to check for valid inputs
// 3. Added memory keyword to struct declaration in Log contract
// 4. Added newMessage variable to addMessage function in Log contract to create a new struct instance and push it to the history array.