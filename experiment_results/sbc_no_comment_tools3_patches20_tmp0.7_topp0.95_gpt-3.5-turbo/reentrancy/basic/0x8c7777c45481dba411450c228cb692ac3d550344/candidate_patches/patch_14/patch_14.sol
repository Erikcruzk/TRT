pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit); // Changed if statement to require statement
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit"); // Capitalized function name
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // Added require statement
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut"); // Capitalized function name
        msg.sender.transfer(_am); // Changed call to transfer
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}