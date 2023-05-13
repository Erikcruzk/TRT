pragma solidity ^0.5.0;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;

    constructor(address _log) public {
        TransferLog = new Log();
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }

    function() external payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory newMessage = Message(_adr, _data, _val, now);
        history.push(newMessage);
    }
}