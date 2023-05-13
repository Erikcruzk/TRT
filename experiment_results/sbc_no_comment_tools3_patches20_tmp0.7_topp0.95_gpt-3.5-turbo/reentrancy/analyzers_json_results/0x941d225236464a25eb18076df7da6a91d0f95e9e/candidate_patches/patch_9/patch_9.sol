pragma solidity ^0.4.19;

contract ETH_FUND {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log transferLog;

    uint lastBlock;

    function ETH_FUND(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
        balances[msg.sender] += msg.value;
        transferLog.addMessage(msg.sender, msg.value, "Deposit");
        lastBlock = block.number;
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        require(block.number > lastBlock);
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
        Message memory lastMsg = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(lastMsg);
    }
} 

// Changes Made:
// 1. Renamed MinDeposit to minDeposit for consistency.
// 2. Added require statements to deposit and cashOut functions to prevent invalid inputs.
// 3. Replaced msg.sender.call.value with msg.sender.transfer in cashOut function to prevent reentrancy attack.
// 4. Renamed TransferLog to transferLog for consistency.
// 5. Renamed Log function addMessage to follow lowerCamelCase naming convention. 
// 6. Changed struct initialization syntax to avoid warning.