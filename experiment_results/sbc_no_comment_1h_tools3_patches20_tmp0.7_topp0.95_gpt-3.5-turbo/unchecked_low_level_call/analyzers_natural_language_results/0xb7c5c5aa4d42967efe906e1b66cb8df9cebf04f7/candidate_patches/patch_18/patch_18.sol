pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // Check if the balance is greater than 0 before making the call
        if(msg.sender.call.value(balances[msg.sender])()) {
            balances[msg.sender] = 0;
        }
    }
}