pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;
    uint public minDeposit = 1 ether;
    Log transferLog;

    function PrivateBank(address _log) public {
        transferLog = Log(_log);
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            balances[msg.sender] += msg.value;
            transferLog.addMessage(msg.sender, msg.value, "Deposit");
        }
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
    Message lastMsg;

    function addMessage(address _adr, uint _val, string _data) public {
        lastMsg.sender = _adr;
        lastMsg.time = now;
        lastMsg.val = _val;
        lastMsg.data = _data;
        history.push(lastMsg);
    }
} 

// Changes made:
// 1. Renamed the contract to PrivateBank as per Solidity naming conventions.
// 2. Made the constructor of the PrivateBank contract public.
// 3. Renamed MinDeposit to minDeposit as per Solidity naming conventions.
// 4. Changed the CashOut function to use the require statement to prevent underflow attacks.
// 5. Changed the CashOut function to use the transfer() method instead of call.value() to prevent reentrancy attacks.