pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); //added require statement
        msg.sender.transfer(balances[msg.sender]); //replaced low level call with transfer
        balances[msg.sender] = 0;
    }
}