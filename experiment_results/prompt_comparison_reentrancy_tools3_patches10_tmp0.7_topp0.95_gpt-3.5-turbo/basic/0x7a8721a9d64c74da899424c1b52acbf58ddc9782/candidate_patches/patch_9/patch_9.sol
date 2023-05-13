pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than or equal to MinDeposit.");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        require(msg.sender.call{value: _am}(), "Transaction failed.");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
    }

    fallback() external payable {}

    receive() external payable {}

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
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = block.timestamp;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}