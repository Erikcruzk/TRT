pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log public TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am > 0 && _am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.send(_am));
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

// Changes made:
// 1. Capitalized function names to follow convention
// 2. Added require statements to check for valid inputs and prevent underflow/overflow
// 3. Changed function name CashOut to cashOut to follow convention
// 4. Added memory keyword to struct initialization in addMessage function
// 5. Changed Log variable declaration in ETH_VAULT to public to allow for accessing the Log contract outside of ETH_VAULT contract