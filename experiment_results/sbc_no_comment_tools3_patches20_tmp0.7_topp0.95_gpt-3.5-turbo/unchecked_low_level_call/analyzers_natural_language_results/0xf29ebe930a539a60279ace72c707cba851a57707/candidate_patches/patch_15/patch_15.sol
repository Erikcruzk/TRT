pragma solidity ^0.4.24;

contract B {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function go(address _target) public payable {
        require(_target != address(0)); // Check that target address is valid

        bool success;
        bytes memory data;

        (success, data) = _target.call.value(msg.value)("");

        require(success); // Check that low-level call was successful

        owner.transfer(address(this).balance);
    }

    function() public payable {}
}