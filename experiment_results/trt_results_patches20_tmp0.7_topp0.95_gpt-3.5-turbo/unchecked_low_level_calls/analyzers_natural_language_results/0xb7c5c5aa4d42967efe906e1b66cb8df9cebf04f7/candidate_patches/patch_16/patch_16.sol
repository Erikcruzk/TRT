pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Added a check to ensure that the balance is greater than zero before making the call
        msg.sender.transfer(balances[msg.sender]); // Changed call to transfer method to send ether to the address
        balances[msg.sender] = 0;
    }
}