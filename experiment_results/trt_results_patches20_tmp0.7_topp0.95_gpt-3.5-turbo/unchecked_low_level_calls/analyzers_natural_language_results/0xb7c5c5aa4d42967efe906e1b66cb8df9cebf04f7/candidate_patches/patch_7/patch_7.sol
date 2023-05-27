pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if the balance is greater than zero
        msg.sender.transfer(balances[msg.sender]); // Use transfer instead of call
        balances[msg.sender] = 0;
    }
}