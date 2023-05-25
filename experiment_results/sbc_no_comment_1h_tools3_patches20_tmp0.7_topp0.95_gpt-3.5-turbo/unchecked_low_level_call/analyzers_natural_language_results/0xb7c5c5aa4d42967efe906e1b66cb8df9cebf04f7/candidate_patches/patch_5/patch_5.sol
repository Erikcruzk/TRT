pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if the balance is greater than zero
        bool success = msg.sender.send(balances[msg.sender]); // Use send() instead of call() and store the return value
        require(success); // Check if the send() was successful
        balances[msg.sender] = 0;
    }
}