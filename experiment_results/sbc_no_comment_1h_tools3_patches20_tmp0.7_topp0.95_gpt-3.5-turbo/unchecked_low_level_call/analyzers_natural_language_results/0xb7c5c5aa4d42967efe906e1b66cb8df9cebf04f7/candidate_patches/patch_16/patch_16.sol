pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Add a check to ensure user has balance to withdraw
        msg.sender.transfer(balances[msg.sender]); // Use transfer instead of low level call
        balances[msg.sender] = 0;
    }
}