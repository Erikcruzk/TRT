pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Added a require statement to check if the balance is greater than 0
        require(msg.sender.call.value(balances[msg.sender])()); // Added a require statement to check if the external call was successful
        balances[msg.sender] = 0;
    }
}