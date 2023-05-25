pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if the sender has balance to withdraw
        uint256 amountToWithdraw = balances[msg.sender];
        balances[msg.sender] = 0; // Set the balance to zero before sending to prevent re-entrancy attack
        msg.sender.transfer(amountToWithdraw); // Use transfer() instead of call() to send ether and check for success
    }
}