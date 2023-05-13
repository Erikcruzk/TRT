pragma solidity ^0.8.0;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    constructor(address _log) {
        TransferLog = new Log();
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit, "Deposit amount should be greater than MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Withdrawal amount should be less than or equal to balance");
        balances[msg.sender] -= _am;
        TransferLog.addMessage(msg.sender, _am, "CashOut");
        payable(msg.sender).transfer(_am);
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    receive() external payable {
        deposit();
    }
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
        Message memory newMessage = Message(_adr, _data, _val, block.timestamp);
        history.push(newMessage);
    }
} 

// Changes made:
// 1. Changed the contract name to PrivateBank
// 2. Added constructor to initialize TransferLog
// 3. Changed function names to follow Solidity naming conventions
// 4. Used require statements to validate input
// 5. Removed payable from cashOut function and transferred funds using transfer() instead
// 6. Added getBalance() function to view account balance
// 7. Updated Log contract to push new messages as a struct instead of updating existing struct
// 8. Updated variable and function names to follow Solidity naming conventions.