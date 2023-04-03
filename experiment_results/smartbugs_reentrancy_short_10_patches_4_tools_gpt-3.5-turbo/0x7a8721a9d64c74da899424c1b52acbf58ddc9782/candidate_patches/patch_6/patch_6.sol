/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 52
 */

pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping (address => uint) public balances;
    uint public MinDeposit = 1 ether;
    address public owner;
    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function PrivateDeposit() {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) onlyOwner {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        if(msg.value >= MinDeposit) {
            balances[msg.sender] += msg.value;
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
        }
    }

    function CashOut(uint _am) public {
        if(_am <= balances[msg.sender]) {
            balances[msg.sender] -= _am;
            TransferLog.AddMessage(msg.sender, _am, "CashOut");
            (bool success, ) = msg.sender.call{value: _am}("");
            require(success, "Transfer failed.");
        }
    }

    receive() external payable {}

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

    function AddMessage(address _adr, uint _val, string memory _data) public {
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

// Changes Made:
// - Updated the Solidity version to ^0.8.0
// - Replaced tx.origin with msg.sender in the onlyOwner modifier
// - Added a check to ensure that the transfer of funds in CashOut() is successful
// - Replaced now with block.timestamp to get the current time
// - Updated the Log contract to use memory instead of storage for the string parameter in AddMessage() function.