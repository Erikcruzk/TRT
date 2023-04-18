pragma solidity ^0.8.0;

contract ETH_VAULT {
    mapping(address => uint256) public balances;

    Log TransferLog;

    uint256 public MinDeposit = 1 ether;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint256 _am) public payable {
        require(balances[msg.sender] >= _am, "Insufficient balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
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

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: block.timestamp,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
}

// This Solidity Smart Contract has been analyzed by smart contract analyzers. Here are the results from these analyzers.

// No vulnerabilities found.