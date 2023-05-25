pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // added require statement to check if there are available funds to withdraw
        msg.sender.transfer(balances[msg.sender]); // changed call function to transfer function to ensure that the correct amount is sent to the correct address
        balances[msg.sender] = 0;
    }
}