pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if sender has balance to withdraw
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        require(msg.sender.send(amount)); // Send the balance to the sender
    }
}