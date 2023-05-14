pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // add a check to ensure there are funds to withdraw
        msg.sender.transfer(balances[msg.sender]); // use transfer instead of call
        balances[msg.sender] = 0;
    }
}