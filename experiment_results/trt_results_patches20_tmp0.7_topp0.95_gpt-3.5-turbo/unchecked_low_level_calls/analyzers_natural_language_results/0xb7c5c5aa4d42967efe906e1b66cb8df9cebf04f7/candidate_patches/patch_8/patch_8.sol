pragma solidity ^0.4.23;

contract keepMyEther {
    mapping(address => uint256) public balances;

    function() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        require(balances[msg.sender] > 0); // added require statement to check if the balance is greater than zero before sending ether
        if(msg.sender.send(balances[msg.sender])){ // changed call to send and added an if statement to check if the transfer was successful
            balances[msg.sender] = 0;
        }
    }
}