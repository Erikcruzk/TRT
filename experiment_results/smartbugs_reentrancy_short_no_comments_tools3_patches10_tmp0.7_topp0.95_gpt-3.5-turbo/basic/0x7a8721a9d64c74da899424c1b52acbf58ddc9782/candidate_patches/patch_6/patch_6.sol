pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping (address => uint) public balances;
    uint public minDeposit = 1 ether;
    address public owner;
    Log public transferLog;

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
        if(msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint _am) public {
        if(_am <= balances[msg.sender]) {            
            if(msg.sender.send(_am)) {
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
        Message memory newMsg;
        newMsg.sender = _adr;
        newMsg.time = now;
        newMsg.val = _val;
        newMsg.data = _data;
        history.push(newMsg);
    }
}