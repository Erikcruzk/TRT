pragma solidity ^0.8.0;

contract WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    Log LogFile;

    uint public MinSum = 1 ether;

    constructor(address log) {
        LogFile = Log(log);
    }

    function Put(uint _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        LogFile.AddMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or locked funds");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        LogFile.AddMessage(msg.sender, _am, "Collect");
    }

    receive() external payable {
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

    function AddMessage(address _adr, uint _val, string memory _data) public {
        History.push(Message(_adr, _data, _val, block.timestamp));
    }
} 

// Changes Made:
// 1. Fixed integer overflow/underflow vulnerability by updating the Solidity version and replacing 'var' with 'Holder storage'
// 2. Fixed reentrancy vulnerability by adding a require statement to check if the balance is sufficient and the funds are unlocked before transferring the amount and updating the balance. Also, added a check for successful transfer after the transfer is made.
// 3. Updated the constructor syntax to match the latest Solidity version.
// 4. Removed the unused 'LastMsg' variable and replaced it with a direct push to the History array.