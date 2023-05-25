pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check that balance is not zero before making the call
        msg.sender.transfer(balances[msg.sender]); // Use transfer instead of call to prevent re-entrancy attack
        balances[msg.sender] = 0;
    }
}