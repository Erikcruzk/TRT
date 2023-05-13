pragma solidity ^0.5.0;

contract PrivateBank {
    mapping(address => uint256) public balances;

    uint256 public minDeposit = 1 ether;

    event Log(address indexed sender, uint256 value, string action);

    function deposit() public payable {
        if (msg.value > minDeposit) {
            balances[msg.sender] += msg.value;
            emit Log(msg.sender, msg.value, "Deposit");
        }
    }

    function cashOut(uint256 _amount) public {
        require(_amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        emit Log(msg.sender, _amount, "CashOut");
    }

    function() external payable {}
}