pragma solidity ^0.4.19;

contract ETH_VAULT {
    mapping(address => uint) public balances;

    Log TransferLog;

    uint public MinDeposit = 1 ether;
    bool private stopped = false;

    function ETH_VAULT(address _log) public {
        TransferLog = Log(_log);
    }

    function Deposit() public payable {
        require(!stopped);
        require(msg.value >= MinDeposit);
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint _am) public payable {
        require(!stopped);
        require(_am <= balances[msg.sender]);
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
    }

    function() public payable {}

    function stopContract() public {
        require(msg.sender == TransferLog.owner());
        stopped = true;
    }

    function startContract() public {
        require(msg.sender == TransferLog.owner());
        stopped = false;
    }
}

contract Log {
    address public owner;
    
    struct Message {
        address Sender;
        string Data;
        uint Val;
        uint Time;
    }

    Message[] public History;

    Message LastMsg;

    function Log() public {
        owner = msg.sender;
    }

    function AddMessage(address _adr, uint _val, string _data) public {
        require(msg.sender == owner);
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

/*
Changes made:
1. Added require statements to ensure that the contract is not stopped before executing the Deposit and CashOut functions.
2. Replaced the call.value function with a transfer function to prevent reentrancy attacks.
3. Added a stopContract and startContract function to allow the contract owner to stop and start the contract, respectively.
4. Added an owner variable to the Log contract and modified the AddMessage function to only allow the owner to add messages to the History array.
*/