pragma solidity ^0.5.0;

contract PrivateBank {
    mapping (address => uint) public balances;

    uint public minDeposit = 1 ether;

    event LogDeposit(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint amount);

    function deposit() public payable {
        require(msg.value >= minDeposit, "Deposit amount should be greater than or equal to min deposit amount.");
        balances[msg.sender] += msg.value;
        emit LogDeposit(msg.sender, msg.value);
    }

    function cashOut(uint _am) public {
        require(_am <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= _am;
        msg.sender.transfer(_am);
        emit LogWithdrawal(msg.sender, _am);
    }

    function() external payable {}

}