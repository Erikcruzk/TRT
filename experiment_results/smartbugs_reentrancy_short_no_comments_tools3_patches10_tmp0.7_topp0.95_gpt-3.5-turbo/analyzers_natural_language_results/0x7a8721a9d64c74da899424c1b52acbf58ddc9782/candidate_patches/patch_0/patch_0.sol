pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping(address => uint256) public balances;

    uint256 public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
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
        require(msg.value >= MinDeposit, "Minimum deposit amount not met.");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    receive() external payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint256 _val, string memory _data)
        public
    {
        Message memory LastMsg = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }
} 

// Changes made:
// 1. Updated the compiler version to ^0.8.0
// 2. Added visibility modifiers to functions for better security
// 3. Replaced tx.origin with msg.sender to prevent potential security issues
// 4. Added require statements to check for errors and prevent vulnerabilities
// 5. Moved the struct variable declaration inside the function to avoid potential errors
// 6. Added a receive function to accept Ether transfers.