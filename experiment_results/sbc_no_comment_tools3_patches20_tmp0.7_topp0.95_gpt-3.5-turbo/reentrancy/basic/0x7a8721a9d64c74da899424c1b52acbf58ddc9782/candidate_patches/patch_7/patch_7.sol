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
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        if (msg.sender.call.value(_am)()) {
            transferLog.addMessage(msg.sender, _am, "CashOut");
        } else {
            balances[msg.sender] += _am;
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

//Changes made:
//1. Changed MinDeposit to minDeposit, to follow Solidity naming conventions.
//2. Changed require(tx.origin == owner) to require(msg.sender == owner), to avoid potential security vulnerabilities.
//3. Added 'public' visibility modifier to all functions for better readability and ease of use.
//4. Changed CashOut function to first require the requested amount to be less than or equal to the user's balance, to avoid potential re-entrancy attacks. 
//5. Added a check to make sure balances are only updated if the call to withdraw is successful. 
//6. Added a memory declaration for the lastMsg struct in addMessage function.