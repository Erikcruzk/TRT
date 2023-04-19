pragma solidity ^0.8.0;

contract U_BANK {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;
    uint public MinSum = 2 ether;

    event LogMessage(address indexed sender, uint value, string message);

    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        emit LogMessage(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or unlock time not reached");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        emit LogMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
        put(0);
    }
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint value;
        uint time;
    }

    Message[] public history;

    function addMessage(address _sender, uint _value, string memory _data) public {
        history.push(Message(_sender, _data, _value, block.timestamp));
    }
}