pragma solidity ^0.8.0;

contract Wallet {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping(address => Holder) public acc;
    uint public minSum = 1 ether;
    Log logFile;

    constructor(address log) {
        logFile = Log(log);
    }

    function put(uint _unlockTime) public payable {
        acc[msg.sender].balance += msg.value;
        acc[msg.sender].unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        logFile.addMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        require(acc[msg.sender].balance >= minSum && acc[msg.sender].balance >= _am && block.timestamp > acc[msg.sender].unlockTime, "Insufficient balance or unlock time not reached");
        acc[msg.sender].balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        logFile.addMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
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

    Message[] public history;

    function addMessage(address _adr, uint _val, string memory _data) public {
        history.push(Message({
            sender: _adr,
            time: block.timestamp,
            val: _val,
            data: _data
        }));
    }
}

// Changes Made:
// 1. Renamed the contract to Wallet with a capital W.
// 2. Changed the version to ^0.8.0.
// 3. Changed var to the explicit data type.
// 4. Changed now to block.timestamp for clarity.
// 5. Added explicit visibility modifiers to functions.
// 6. Added require statements to check for conditions and revert if not met.
// 7. Changed the LogFile variable name to logFile to follow Solidity naming conventions.
// 8. Added a constructor to initialize the Log contract address.
// 9. Changed the push statement in the Log contract to use struct literal syntax.