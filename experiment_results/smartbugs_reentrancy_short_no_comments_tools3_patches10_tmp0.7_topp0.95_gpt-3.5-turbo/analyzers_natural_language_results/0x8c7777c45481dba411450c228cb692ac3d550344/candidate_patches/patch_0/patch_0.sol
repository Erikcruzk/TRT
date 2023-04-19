pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    Log TransferLog;
    uint public MinDeposit = 1 ether;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public {
        require(_am > 0, "Cash out amount must be greater than zero");
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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
            Data: _data,
            Val: _val,
            Time: block.timestamp
        });
        History.push(newMessage);
    }
}