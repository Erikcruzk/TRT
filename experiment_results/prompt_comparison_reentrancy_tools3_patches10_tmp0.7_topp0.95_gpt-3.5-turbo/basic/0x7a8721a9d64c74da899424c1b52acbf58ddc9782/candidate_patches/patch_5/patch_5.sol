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

    function setLog(address _lib) public onlyOwner {
        transferLog = Log(_lib);
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        if (_am <= balances[msg.sender]) {
            if (msg.sender.call.value(_am)()) {
                balances[msg.sender] -= _am;
                transferLog.addMessage(msg.sender, _am, "CashOut");
            }
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

// Changes made:
// 1. Changed MinDeposit to minDeposit to follow Solidity naming conventions
// 2. Changed require(tx.origin == owner) to require(msg.sender == owner) for better security
// 3. Added visibility specifier "public" to all functions
// 4. Added "memory" keyword to the Message struct in the Log contract
// 5. Added a new Message struct in the addMessage function of the Log contract to avoid overwriting previous messages in the history array.