pragma solidity ^0.4.25;

contract WALLET {
    bool private locked;
    mapping(address => uint) public balances;
    uint public minSum = 1 ether;
    
    event LogDeposit(address sender, uint amount);
    event LogWithdrawal(address receiver, uint amount);
    event LogLock();

    function deposit() public payable {
        require(msg.value > 0);
        balances[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(!locked);
        require(balances[msg.sender] >= amount && amount >= minSum);
        locked = true;
        if (msg.sender.call.value(amount)()) {
            balances[msg.sender] -= amount;
            emit LogWithdrawal(msg.sender, amount);
            locked = false;
        } else {
            locked = false;
            revert();
        }
    }

    function() public payable {
        deposit();
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
    Message lastMsg;
    
    function addMessage(address sender, uint val, string data) public {
        lastMsg.sender = sender;
        lastMsg.time = now;
        lastMsg.val = val;
        lastMsg.data = data;
        history.push(lastMsg);
    }
}