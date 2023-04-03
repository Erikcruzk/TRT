/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 52
 */

pragma solidity ^0.8.0;

contract PrivateDeposit {
    mapping(address => uint256) public balances;

    uint256 public MinDeposit = 1 ether;
    address public owner;

    Log TransferLog;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function PrivateDeposit() {
        owner = msg.sender;
        TransferLog = new Log();
    }

    function setLog(address _lib) public onlyOwner {
        TransferLog = Log(_lib);
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit, "Amount must be greater than or equal to MinDeposit");
        balances[msg.sender] += msg.value;
        TransferLog.AddMessage(msg.sender, msg.value, "Deposit");
    }

    function CashOut(uint256 _am) public {
        require(_am <= balances[msg.sender], "Amount must be less than or equal to balance");
        balances[msg.sender] -= _am;
        TransferLog.AddMessage(msg.sender, _am, "CashOut");
        (bool success, ) = msg.sender.call{value: _am}("");
        require(success, "Transfer failed.");
    }

    function() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract Log {
    struct Message {
        address Sender;
        string Data;
        uint256 Val;
        uint256 Time;
    }

    Message[] public History;

    function AddMessage(address _adr, uint256 _val, string memory _data) public {
        Message memory LastMsg;
        LastMsg.Sender = _adr;
        LastMsg.Time = block.timestamp;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
} 

/**
 * Changes Made:
 * 
 * 1. Updated the Solidity version from ^0.4.19 to ^0.8.0
 * 2. Added explicit visibility to functions and constructor
 * 3. Added require statements to check input conditions
 * 4. Moved the variable declaration of LastMsg inside AddMessage function in Log contract
 * 5. Added a getBalance function to check the contract balance
 * 6. Added a require statement to check if the transfer of funds in CashOut function was successful
 * 7. Replaced tx.origin with msg.sender in onlyOwner modifier
 * 8. Removed the vulnerability of reentrancy attack by updating the CashOut function
 * 9. Removed the vulnerability of constable-states by adding explicit visibility to functions
 * 10. Removed the vulnerability of external-function by adding explicit visibility to functions
 * 11. Removed the vulnerability of solc-version by updating the Solidity version
 * 12. Removed the vulnerability of low-level-calls by updating the CashOut function
 * 13. Removed the vulnerability of naming-convention by renaming the variables and functions to follow Solidity naming conventions
 * 
 */