pragma solidity ^0.5.0;

contract ETH_VAULT {
    mapping (address => uint256) private balances;
    Log private transferLog;
    uint256 public minDeposit = 1 ether;

    constructor(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount must be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function() external payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }
    Message[] private history;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        history.push(Message(_adr, _data, _val, now));
    }

    function getLastMessage() public view returns (address, string memory, uint256, uint256) {
        uint256 lastIndex = history.length - 1;
        Message memory lastMessage = history[lastIndex];
        return (lastMessage.sender, lastMessage.data, lastMessage.val, lastMessage.time);
    }
} 

// Changes Made:
// 1. Updated the Solidity version to ^0.5.0.
// 2. Changed the visibility of balances and transferLog to private for security reasons.
// 3. Changed the function names to follow the Solidity naming conventions.
// 4. Added require statements to ensure the input values are valid and the balance is sufficient.
// 5. Replaced the call function with transfer in cashOut function to avoid reentrancy vulnerability.
// 6. Added a getBalance function to allow users to check their balance.
// 7. Updated the addMessage function to use constructor-like syntax and added a getLastMessage function to retrieve the last message from the history array.