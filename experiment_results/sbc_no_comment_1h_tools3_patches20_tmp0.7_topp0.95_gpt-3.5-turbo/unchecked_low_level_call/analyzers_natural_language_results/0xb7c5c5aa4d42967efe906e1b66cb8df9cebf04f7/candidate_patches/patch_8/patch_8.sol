pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // check that the sender has a balance to withdraw
        msg.sender.transfer(balances[msg.sender]); // use transfer instead of call to send ether
        balances[msg.sender] = 0;
    }
}