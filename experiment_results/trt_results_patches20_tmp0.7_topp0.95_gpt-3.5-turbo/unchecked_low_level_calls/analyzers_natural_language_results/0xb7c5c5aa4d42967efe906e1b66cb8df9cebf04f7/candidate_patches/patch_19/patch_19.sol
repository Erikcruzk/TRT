pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Add a require statement to check if the balance is greater than 0 before making the call
        require(msg.sender.call.value(balances[msg.sender])()); // Check the return value of the call and revert the transaction if it fails
        balances[msg.sender] = 0;
    }
}