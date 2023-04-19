pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint256) public balances;
    uint256 public minDeposit = 1 ether;
    Log transferLog;

    function ETH_VAULT(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
    }

    function () public payable {}    
}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }

    Message[] public history;

    function addMessage(address _adr, uint256 _val, string _data) public {
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
}