pragma solidity ^0.4.24;

contract B {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function go(address _target) public payable {
        require(_target != address(0));
        require(msg.value > 0);

        bool success = _target.call.value(msg.value)("");

        require(success, "Low level call failed");
        owner.transfer(address(this).balance);
    }

    function() public payable {}
}