pragma solidity ^0.5.0;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call.value(balance)("");
        require(success, "Transfer failed");
    }
}