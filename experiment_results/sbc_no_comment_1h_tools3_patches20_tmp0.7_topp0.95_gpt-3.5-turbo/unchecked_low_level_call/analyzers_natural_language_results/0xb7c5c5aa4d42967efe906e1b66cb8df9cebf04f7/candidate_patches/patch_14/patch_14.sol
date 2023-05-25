pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); //check if the balance is greater than zero before making the call
        bool success = msg.sender.call.value(balances[msg.sender])();
        require(success); //check if the call was successful
        balances[msg.sender] = 0;
    }
}