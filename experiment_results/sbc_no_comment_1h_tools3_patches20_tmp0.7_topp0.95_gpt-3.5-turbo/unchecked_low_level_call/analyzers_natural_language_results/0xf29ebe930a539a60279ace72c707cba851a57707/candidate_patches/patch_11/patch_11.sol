pragma solidity ^0.4.24;

contract B {
    address public owner = msg.sender;

    function go(address _target) public payable {
        require(_target != address(0)); // check if the target address is valid
        require(msg.value > 0); // check if the value sent is greater than 0
        bool success = _target.call.value(msg.value)();
        require(success); // check if the low level call was successful
        owner.transfer(address(this).balance);
    }

    function() public payable {}
}