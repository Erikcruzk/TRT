pragma solidity ^0.8.0;

contract W_WALLET {
    struct Holder {
        uint unlockTime;
        uint balance;
    }

    mapping (address => Holder) public Acc;

    uint public MinSum = 1 ether;

    event LogFile(address indexed sender, uint value, string data);

    function put(uint _unlockTime) public payable {
        Acc[msg.sender].balance += msg.value;
        Acc[msg.sender].unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        emit LogFile(msg.sender, msg.value, "Put");
    }

    function collect(uint _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or unlock time not reached");
        acc.balance -= _am;
        (bool success,) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        emit LogFile(msg.sender, _am, "Collect");
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

    event AddMessage(address indexed sender, uint value, string data);

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg = Message(_adr, _data, _val, block.timestamp);
        history.push(lastMsg);
        emit AddMessage(_adr, _val, _data);
    }
}