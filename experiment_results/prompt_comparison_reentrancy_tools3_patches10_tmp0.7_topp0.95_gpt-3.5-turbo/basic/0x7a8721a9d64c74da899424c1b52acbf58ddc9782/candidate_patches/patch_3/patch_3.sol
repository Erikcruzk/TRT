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
            if (msg.sender.send(_am)) {
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
        Message memory newMessage;
        newMessage.sender = _adr;
        newMessage.time = now;
        newMessage.val = _val;
        newMessage.data = _data;
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed MinDeposit to minDeposit as per standard naming convention
// 2. Changed constructor function name to be same as contract name
// 3. Changed require statement in onlyOwner modifier to check msg.sender instead of tx.origin
// 4. Added public modifier to all functions for visibility
// 5. Changed call.value to send in cashOut function to prevent re-entrancy attack
// 6. Added memory keyword while creating a new Message in addMessage function to avoid storage allocation error