pragma solidity ^0.4.19;

contract PrivateDeposit {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function PrivateDeposit() public {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
// 1. Added 'public' visibility to the constructor and functions.
// 2. Changed 'tx.origin' to 'msg.sender' in onlyOwner modifier.
// 3. Changed 'Deposit' function name to 'deposit' and added 'require' for minimum deposit check.
// 4. Changed 'CashOut' function name to 'cashOut', added 'require' for balance check and rearranged the order of operations to prevent re-entrancy attacks.
// 5. Changed variable names to follow Solidity naming conventions.
// 6. Added 'memory' keyword to 'Message' struct in 'Log' contract to fix compiler error.
// 7. Changed 'LastMsg' variable to a local variable 'lastMsg' in 'addMessage' function to prevent overwriting the previous message.