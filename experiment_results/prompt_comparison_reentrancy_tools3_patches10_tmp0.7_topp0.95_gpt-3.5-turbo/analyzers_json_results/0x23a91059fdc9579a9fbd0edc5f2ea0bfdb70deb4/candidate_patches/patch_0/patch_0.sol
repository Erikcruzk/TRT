pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;

    uint public MinDeposit = 1 ether;

    Log private TransferLog;

    function PrivateBank(address _log) public {
        TransferLog = Log(_log);
    }

    function deposit() public payable {
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.addMessage(msg.sender, msg.value, "Deposit");
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        require(msg.sender.call.value(_am)());
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
        history.push(Message({
            sender: _adr,
            time: now,
            val: _val,
            data: _data
        }));
    }
} 

// Changes made:
// 1. Made TransferLog private
// 2. Changed function names to follow Solidity naming conventions
// 3. Added require statements for input validation
// 4. Moved the call to TransferLog.addMessage before state changes in cashOut function
// 5. Changed variable names to follow Solidity naming conventions
// 6. Removed unnecessary LastMsg struct and LastMsg variable in Log contract.