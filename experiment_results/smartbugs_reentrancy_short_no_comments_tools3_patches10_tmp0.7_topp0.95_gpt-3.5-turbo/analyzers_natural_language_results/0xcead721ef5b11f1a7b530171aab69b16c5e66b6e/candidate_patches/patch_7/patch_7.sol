pragma solidity ^0.8.0;

contract WALLET {
    struct Holder {
        uint256 unlockTime;
        uint256 balance;
    }

    mapping(address => Holder) public Acc;
    uint256 public MinSum = 1 ether;

    event LogMessage(address indexed _sender, uint256 _value, string _data);

    function Put(uint256 _unlockTime) public payable {
        Holder storage acc = Acc[msg.sender];
        acc.balance += msg.value;
        acc.unlockTime = _unlockTime > block.timestamp ? _unlockTime : block.timestamp;
        emit LogMessage(msg.sender, msg.value, "Put");
    }

    function Collect(uint256 _am) public payable {
        Holder storage acc = Acc[msg.sender];
        require(acc.balance >= MinSum && acc.balance >= _am && block.timestamp > acc.unlockTime, "Insufficient balance or unlock time not reached");
        acc.balance -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed");
        emit LogMessage(msg.sender, _am, "Collect");
    }

    function() external payable {
        Put(0);
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        History.push(Message(_adr, _data, _val, block.timestamp));
    }
}