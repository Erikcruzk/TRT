pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public minDeposit = 1 ether;

    constructor(address _log) {
        TransferLog = new Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount should be greater than or equal to the minimum deposit amount");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        require(payable(msg.sender).send(_am), "Transfer failed");
        TransferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function() external payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}