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
            val: _val,
            data: _data,
            time: now
        });
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Renamed functions and variables to follow Solidity naming conventions.
// 2. Replaced if statements with require statements for better readability and security.
// 3. Removed payable modifier from cashOut function and used transfer instead of call.value for security against reentrancy attacks.
// 4. Changed struct member capitalization to follow Solidity naming conventions.
// 5. Added memory keyword to create a new struct in addMessage function.