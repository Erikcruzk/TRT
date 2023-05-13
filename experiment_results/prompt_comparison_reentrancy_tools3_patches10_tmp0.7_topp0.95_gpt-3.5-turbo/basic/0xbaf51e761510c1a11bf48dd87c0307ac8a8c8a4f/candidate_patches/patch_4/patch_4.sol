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
        require(msg.sender.send(_am));
        transferLog.addMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }
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

// Changes Made:
// 1. Changed MinDeposit to minDeposit, as per Solidity naming conventions.
// 2. Added a require statement in deposit() function to ensure that the deposit amount is greater than or equal to minDeposit.
// 3. Changed CashOut function to only accept an input parameter for the withdrawal amount, and removed the payable keyword. 
// 4. Added a require statement to check if the user has sufficient balance for the requested withdrawal.
// 5. Changed the transfer of funds to msg.sender.send(_am) instead of using msg.sender.call.value(_am)(), as it is the recommended way of transferring funds in Solidity.
// 6. Added a getBalance() function to allow users to view their account balance.
// 7. Changed the struct and variable names to follow Solidity naming conventions.