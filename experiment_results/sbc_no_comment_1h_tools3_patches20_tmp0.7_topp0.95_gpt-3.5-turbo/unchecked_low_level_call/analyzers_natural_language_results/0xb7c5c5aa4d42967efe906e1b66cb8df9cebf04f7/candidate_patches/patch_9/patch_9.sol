pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if sender has balance
        uint256 amount = balances[msg.sender]; // Store balance in variable
        balances[msg.sender] = 0; // Set balance to 0 before transfer to prevent re-entrancy attack
        msg.sender.transfer(amount); // Transfer balance back to sender
    }
}