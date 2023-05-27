pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if balance is greater than 0 before transfer
        msg.sender.transfer(balances[msg.sender]); // Use transfer() instead of call() and return value is checked
        balances[msg.sender] = 0;
    }
}