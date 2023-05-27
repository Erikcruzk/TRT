pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // check if sender has a balance to withdraw
        uint256 amount = balances[msg.sender]; // store the amount to withdraw
        balances[msg.sender] = 0; // update sender's balance to zero
        msg.sender.transfer(amount); // transfer the amount to the sender's address
    }
}