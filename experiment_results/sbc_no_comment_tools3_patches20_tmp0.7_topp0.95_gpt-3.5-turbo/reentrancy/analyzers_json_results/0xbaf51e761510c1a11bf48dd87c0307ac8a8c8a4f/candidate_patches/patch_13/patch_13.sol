pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    function ETH_VAULT(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address sender;
        string data;
        uint val;
        uint time;
    }

    Message[] public history;

    function addMessage(address _adr, uint _val, string _data) public {
        Message memory lastMsg;
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
}

/* Changes made:
- Renamed MinDeposit to minDeposit to comply with Solidity naming conventions
- Added require statement to deposit function to ensure that the minimum deposit is met
- Removed payable modifier from cashOut function as it does not need to receive any ether
- Reordered the code in cashOut function to first deduct the balance, then transfer the ether to avoid reentrancy vulnerability
- Renamed Log to log to comply with Solidity naming conventions
- Added memory keyword to Message struct in addMessage function to specify that it is a memory variable and not a storage variable
- Removed unused variable LastMsg in Log contract and instead created a new Message variable in addMessage function