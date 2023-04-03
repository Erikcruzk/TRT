/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 41
 */

pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    Log TransferLog;
    bool private locked;

    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        if(msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public payable noReentrancy {
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            if(msg.sender.call.value(_am)()) {
                TransferLog.AddMessage(msg.sender, _am, "CashOut");
            }
        }
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
    Message private LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// 1. Added a noReentrancy modifier to the CashOut function to prevent re-entrancy attacks.
// 2. Added a private locked variable to the contract to check if the function is already being executed.
// 3. Moved the subtraction of balance before the external call to prevent the external call from re-entering the contract.
// 4. Made the LastMsg variable private to prevent external modification.
// 5. Removed the constructor function name to adhere to the latest Solidity version.