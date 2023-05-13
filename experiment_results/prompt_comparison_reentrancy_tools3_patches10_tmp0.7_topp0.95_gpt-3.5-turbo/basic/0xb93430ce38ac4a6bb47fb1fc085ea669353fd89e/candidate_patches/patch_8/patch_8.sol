pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    function PrivateBank(address _lib) public { // added 'public'
        TransferLog = new Log(); // changed from 'Log(_lib)' to 'new Log()'
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit); // added 'require'
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender]); // added 'require'
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am); // changed from 'msg.sender.call.value(_am)()' to 'msg.sender.transfer(_am)'
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
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