pragma solidity ^0.5.0;

contract ETH_FUND {
    mapping (address => uint) public balances;
    uint public minDeposit = 1 ether;
    Log transferLog;
    uint lastBlock;

    constructor(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than minimum deposit");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance");
        require(block.number > lastBlock, "Cannot perform cash out before last block");
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
    Message lastMsg;

    function addMessage(address _adr, uint _val, string memory _data) public {
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}