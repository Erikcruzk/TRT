pragma solidity ^0.4.25;

contract MY_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }
    
    mapping(address => Holder) public Acc;
    
    Log LogFile;

    uint public MinSum = 1 ether;

    function MY_BANK(address log) public {
        LogFile = Log(log);
    }
    
    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > now ? _unlockTime : now;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && now > acc.unlockTime);
        acc.balance -= _am;
        msg.sender.transfer(_am);
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    function() public payable {
        Put(0);
    }
}

contract Log {
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

// Changes made:
// 1. Moved the struct Holder and mapping Acc to the top of the contract
// 2. Changed the type of 'acc' variable in Put() and Collect() functions to 'Holder storage'
// 3. Removed 'payable' from the Collect() function and replaced the 'call.value' with 'transfer'
// 4. Added 'require' statement to check balance and unlock time in Collect() function
// 5. Changed LogFile.AddMessage() function to use a temporary variable 'newMessage' in Log contract's AddMessage() function, to avoid overwriting the previous message values in the History array.