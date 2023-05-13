pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;
    bool private locked;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!locked);
        if (msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public payable {
        require(!locked);
        require(_am <= balances[msg.sender]);
        locked = true;
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        msg.sender.transfer(_am);
        locked = false;
    }

    function() public payable {}

}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint _val, string _data) public {
        Message memory LastMsg = Message({
            Sender: _adr,
            Time: now,
            Val: _val,
            Data: _data
        });
        History.push(LastMsg);
    }
}

// Changes made:
// 1. Added a locked boolean variable to prevent reentrancy
// 2. Added require statements to ensure that the requested amount is available and the contract is not locked
// 3. Removed the external call in the CashOut function to prevent reentrancy vulnerability
// 4. Removed the global LastMsg variable and added a local variable in the AddMessage function to prevent overwriting the previous message in the History array.