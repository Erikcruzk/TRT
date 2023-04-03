/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 41
 * @fixed_at_lines: 41, 44
 */

pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping (address => uint) public balances;
    
    Log TransferLog;
    
    uint public MinDeposit = 1 ether;
    
    bool private reentrancy_lock = false;
    
    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }
    
    function Deposit() public payable {
        if(msg.value > MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }
    
    function CashOut(uint _am) public payable {
        if(!_preventReentrancy() || _am > balances[msg.sender]) {
            revert();
        }
        
        balances[msg.sender] -= _am;
        
        if(!_safeTransfer(msg.sender, _am)) {
            balances[msg.sender] += _am;
            revert();
        }
        
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        
        _releaseReentrancyLock();
    }
    
    function _preventReentrancy() private returns (bool) {
        if(reentrancy_lock) {
            return false;
        }
        reentrancy_lock = true;
        return true;
    }
    
    function _releaseReentrancyLock() private {
        reentrancy_lock = false;
    }
    
    function _safeTransfer(address _to, uint _value) private returns (bool) {
        if(!_to.call.value(_value)()) {
            return false;
        }
        return true;
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