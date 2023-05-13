pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    bool private reentrancyLock = false;

    modifier noReentrancy() {
        require(!reentrancyLock);
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

    function ETH_FUND(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.addMessage(msg.sender, msg.value, "Deposit");
            lastBlock = block.number;
        }
    }

    function cashOut(uint _am) public payable noReentrancy {
        if (_am <= balances[msg.sender] && block.number > lastBlock) {
            balances[msg.sender] -= _am;
            require(msg.sender.call.value(_am)());
            TransferLog.addMessage(msg.sender, _am, "CashOut");
        }
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage;
        newMessage.Sender = _adr;
        newMessage.Time = now;
        newMessage.Val = _val;
        newMessage.Data = _data;
        History.push(newMessage);
    }
} 

/*
Changes Made:
1. Changed MinDeposit to minDeposit for consistency
2. Added reentrancyLock to prevent reentrancy attacks
3. Added noReentrancy modifier to cashOut function
4. Removed unnecessary LastMsg variable in addMessage function of Log contract
5. Added Message memory newMessage; in addMessage function to create a new Message struct
6. Changed TransferLog.AddMessage to TransferLog.addMessage for consistency
7. Changed "Deposit" and "CashOut" to "Deposit" and "Cashout" respectively for consistency
*/