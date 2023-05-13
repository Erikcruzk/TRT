pragma solidity ^0.4.19;

contract MONEY_BOX {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public Acc;

    uint public MinSum;

    Log LogFile;

    bool intitalized;

    function setMinSum(uint _val) public {
        require(!intitalized);
        MinSum = _val;
    }

    function setLogFile(address _log) public {
        require(!intitalized);
        LogFile = Log(_log);
    }

    function initialized() public {
        intitalized = true;
    }

    function put(uint _lockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        if (now + _lockTime > Acc[msg.sender].unlockTime) {
            Acc[msg.sender].unlockTime = now + _lockTime;
        }
        LogFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        require(_am > 0);
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        LogFile.addMessage(msg.sender, _am, "Collect");
        msg.sender.transfer(_am);
    }

    function() public payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public History;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory newMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        History.push(newMsg);
    }
} 

// Changes made:
// 1. Changed function names to follow Solidity naming convention
// 2. Replaced "throw" with "require" for better error handling
// 3. Removed unnecessary "payable" modifier in collect function
// 4. Removed reentrancy vulnerability by transferring funds after updating balance
// 5. Changed struct variable names to follow Solidity naming convention
// 6. Updated addMessage function to use memory instead of storage for better gas optimization