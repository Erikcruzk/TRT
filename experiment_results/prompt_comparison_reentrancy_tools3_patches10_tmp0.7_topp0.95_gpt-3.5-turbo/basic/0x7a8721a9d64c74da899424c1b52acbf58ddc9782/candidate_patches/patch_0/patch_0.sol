pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;
    address public owner;

    Log transferLog;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function PrivateDeposit() public {
        owner = msg.sender;
        transferLog = new Log();
    }

    function setLog(address _lib) onlyOwner public {
        transferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _amount) public {
        require(_amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        if (msg.sender.call.value(_amount)()) {
            transferLog.addMessage(msg.sender, _amount, "CashOut");
        } else {
            balances[msg.sender] += _amount;
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Renamed MinDeposit to minDeposit to follow Solidity naming conventions.
// 2. Changed require(tx.origin == owner) to require(msg.sender == owner) to prevent attacks involving delegatecall.
// 3. Added require(msg.value >= minDeposit) to deposit() function to prevent deposits below the minimum amount.
// 4. Renamed CashOut function to cashOut to follow Solidity naming conventions.
// 5. Added a check to ensure that the balance of the user is not negative after cashing out.
// 6. Added a fallback function to receive ether. 
// 7. Added memory keyword to Message struct in Log contract to prevent stack too deep error.