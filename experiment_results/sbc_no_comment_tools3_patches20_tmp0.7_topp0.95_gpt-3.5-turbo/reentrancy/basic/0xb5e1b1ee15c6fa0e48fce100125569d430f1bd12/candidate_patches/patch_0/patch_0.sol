pragma solidity ^0.4.19;

contract PrivateBank {
    mapping(address => uint) public balances;
    
    uint public minDeposit = 1 ether;
    
    event TransferLog(address indexed sender, uint value, string message);
    
    function deposit() public payable {
        if (msg.value >= minDeposit) {
            balances[msg.sender] += msg.value;
            emit TransferLog(msg.sender, msg.value, "Deposit");
        }
    }
    
    function cashOut(uint _amount) public {
        require(_amount <= balances[msg.sender]);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        emit TransferLog(msg.sender, _amount, "CashOut");
    }
    
    function() public payable {}
}