pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // check if balance is greater than zero
        uint256 amount = balances[msg.sender]; // store the amount to be withdrawn in a variable
        balances[msg.sender] = 0;
        msg.sender.transfer(amount); // use transfer() instead of call() to send ether and revert on failure
    }
}