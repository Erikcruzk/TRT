pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;
    bool private locked = false; // add a reentrancy guard

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit); // use require to check condition
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public payable {
        require(!locked); // use require to check reentrancy guard
        require(_am <= balances[msg.sender]);
        locked = true; // set guard before external call
        if (msg.sender.call.value(_am)()) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
        }
        locked = false; // release guard after external call
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}