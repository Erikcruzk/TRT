pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.addMessage(msg.sender, _am, "CashOut");
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
// 1. Changed MinDeposit to minDeposit to follow Solidity naming conventions.
// 2. Added require statement in the deposit function to check if the value sent is greater than or equal to minDeposit.
// 3. Removed the payable modifier from the cashOut function as it is not required.
// 4. Replaced the call function with the transfer function in the cashOut function to prevent reentrancy attacks.
// 5. Changed variable names to follow Solidity naming conventions.
// 6. Added a local Message variable in the addMessage function to prevent overwriting the last message.