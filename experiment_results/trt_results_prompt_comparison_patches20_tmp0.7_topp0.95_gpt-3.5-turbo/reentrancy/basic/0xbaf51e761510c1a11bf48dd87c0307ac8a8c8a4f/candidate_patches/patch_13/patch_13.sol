pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(payable(msg.sender).send(_am), "Transaction Failed");
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    receive() external payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}