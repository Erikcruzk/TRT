pragma solidity ^0.5.0;

contract ETH_FUND {
    mapping (address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log TransferLog;

    uint lastBlock;

    constructor(address _log) public {
        TransferLog = new Log();
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than minimum deposit");
        balances[msg.sender]+=msg.value;
        TransferLog.addMessage(msg.sender,msg.value,"Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint _am) public payable {
        require(_am <= balances[msg.sender], "Amount should be less than or equal to balance");
        require(block.number > lastBlock, "Cash out not allowed yet");
        (bool success, ) = msg.sender.call.value(_am)("");
        require(success, "Transfer failed");
        balances[msg.sender]-=_am;
        TransferLog.addMessage(msg.sender,_am,"CashOut");
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
        Message memory lastMsg = Message(_adr, _data, _val, now);
        history.push(lastMsg);
    }
}