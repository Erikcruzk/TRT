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
    bool private stopped = false;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!stopped);
        if(msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public payable {
        require(!stopped);
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            msg.sender.transfer(_am);
        }
    }

    function stop() public {
        require(msg.sender == 0xYOURADDRESS);
        stopped = true;
    }

    function start() public {
        require(msg.sender == 0xYOURADDRESS);
        stopped = false;
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
    Message LastMsg;

    function AddMessage(address _adr, uint _val, string _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}

// Changes Made:
// 1. Added a circuit breaker to stop the contract in case of emergency.
// 2. Replaced the vulnerable external call with the transfer() function.
// 3. Added require() statements to ensure that the circuit breaker is not active and that the amount being cashed out is not greater than the balance.