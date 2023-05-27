pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public minDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        require(msg.sender.call.value(_am)());
        balances[msg.sender] -= _am;
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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

/* Changes Made:
- Changed variable name MinDeposit to minDeposit to follow Solidity naming convention
- Added require statement in deposit function to check if msg.value is greater than or equal to minDeposit
- Changed function name CashOut to cashOut to follow Solidity naming convention
- Added two require statements in cashOut function to check if _am is less than or equal to balances[msg.sender] and if msg.sender.call.value(_am)() is successful
- Renamed function AddMessage to addMessage to follow Solidity naming convention
- Changed struct variable names to follow Solidity naming convention
- Changed struct variable type to memory in addMessage function to prevent stack too deep error
*/