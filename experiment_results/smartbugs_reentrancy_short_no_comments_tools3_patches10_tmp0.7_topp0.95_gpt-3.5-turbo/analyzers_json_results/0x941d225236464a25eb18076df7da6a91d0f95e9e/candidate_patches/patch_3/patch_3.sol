pragma solidity ^0.5.0;

contract ETH_FUND {
    mapping (address => uint256) public balances;
    uint256 public minDeposit = 1 ether;
    Log transferLog;
    uint256 lastBlock;

    constructor(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than the minimum deposit amount.");
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        require(block.number > lastBlock, "Withdrawal not allowed yet.");
        balances[msg.sender] -= _am;
        transferLog.addMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call.value(_am)("");
        require(success, "Transfer failed.");
    }

    function() external payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint256 val;
        uint256 time;
    }

    Message[] public history;
    Message lastMsg;

    function addMessage(address _adr, uint256 _val, string memory _data) public {
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}