pragma solidity ^0.8.0;

contract PrivateBank {
    mapping(address => uint256) public balances;
    uint256 public minDeposit = 1 ether;
    Log transferLog;

    constructor(address _lib) {
        transferLog = new Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount should be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Not enough balance");
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    receive() external payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(
        address _adr,
        uint256 _val,
        string memory _data
    ) public {
        Message memory lastMsg = Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
} 

// The repaired contract does the following:
// 1. Updated the Solidity version to 0.8.0
// 2. Added explicit visibility to functions
// 3. Renamed "MinDeposit" to "minDeposit" to follow Solidity naming conventions
// 4. Added a constructor to initialize the "transferLog" variable
// 5. Added require statements to validate input parameters
// 6. Removed the reentrancy vulnerability by transferring funds to the user before updating the balance
// 7. Used the "receive" function instead of the fallback function
// 8. Moved the "LastMsg" variable to the "addMessage" function as it was causing issues in the previous implementation