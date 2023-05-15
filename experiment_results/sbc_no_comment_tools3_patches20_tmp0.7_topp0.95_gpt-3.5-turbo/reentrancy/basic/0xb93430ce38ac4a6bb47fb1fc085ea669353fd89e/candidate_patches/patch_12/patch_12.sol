pragma solidity ^0.5.0;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    constructor(address _lib) public {
        transferLog = Log(_lib);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount should be greater than or equal to minDeposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
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

    function addMessage(address _adr, uint _val, string memory _data) public {
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
}