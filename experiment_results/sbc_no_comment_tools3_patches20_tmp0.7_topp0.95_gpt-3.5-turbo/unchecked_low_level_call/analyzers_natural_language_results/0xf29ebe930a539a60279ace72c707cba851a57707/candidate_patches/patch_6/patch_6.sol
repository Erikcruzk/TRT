pragma solidity ^0.4.24;

contract B {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function go(address _target) public payable {
        require(_target != address(0)); // check if target address is valid

        bool success;
        bytes memory response;
        (success, response) = _target.call.value(msg.value)("");

        require(success); // check if call to target contract was successful

        owner.transfer(address(this).balance);
    }

    function() public payable {}
}