pragma solidity ^0.8.0;

contract PrivateBank {
    mapping (address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    event LogMessage(address indexed _sender, uint _value, string _data, uint _time);
    
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        emit LogMessage(msg.sender, msg.value, "Deposit", block.timestamp);
    }
    
    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
        emit LogMessage(msg.sender, _am, "CashOut", block.timestamp);
    }
    
    function() external payable {}    
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }
    
    Message[] public history;
    
    function addMessage(address _adr, uint _val, string memory _data, uint _time) public {
        Message memory message = Message(_adr, _data, _val, _time);
        history.push(message);
    }
}