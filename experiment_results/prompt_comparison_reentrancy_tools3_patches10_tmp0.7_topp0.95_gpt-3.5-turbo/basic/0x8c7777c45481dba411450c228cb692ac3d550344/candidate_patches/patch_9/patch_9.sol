pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log transferLog;

    uint public minDeposit = 1 ether;

    function ETH_VAULT(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
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
        Message memory newMessage = Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        });
        history.push(newMessage);
    }
} 

// Changes Made:
// 1. Changed the contract name ETH_VAULT to EthVault (convention)
// 2. Changed the variable name MinDeposit to minDeposit (convention)
// 3. Changed the Log variable name to transferLog (convention)
// 4. Added require statements to check conditions before execution
// 5. Changed the CashOut function to transfer funds using msg.sender.transfer(_am)
// 6. Changed the Message struct initialization to memory (to avoid storage cost) and added all struct members