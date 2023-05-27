pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // added require statement to check if balance is greater than 0
        msg.sender.transfer(balances[msg.sender]); // changed call to transfer to send Ether back to msg.sender
        balances[msg.sender] = 0;
    }
}