pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    uint public minDeposit = 1 ether;

    Log TransferLog;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes Made
// 1. Changed the name of MinDeposit to minDeposit to follow Solidity naming conventions
// 2. Used the require statement in deposit function to check the minimum deposit amount
// 3. Removed the payable modifier from the cashOut function as it is not necessary
// 4. Used the transfer function instead of the call function to prevent reentrancy attacks
// 5. Changed the name of AddMessage function to addMessage to follow Solidity naming conventions
// 6. Modified the addMessage function to use a struct to store the new message instead of modifying the LastMsg variable directly
// 7. Changed the variable names in the Message struct to follow Solidity naming conventions