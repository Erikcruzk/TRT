pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // check if the balance is greater than zero
        msg.sender.transfer(balances[msg.sender]); // use transfer instead of low-level call
        balances[msg.sender] = 0;
    }
}