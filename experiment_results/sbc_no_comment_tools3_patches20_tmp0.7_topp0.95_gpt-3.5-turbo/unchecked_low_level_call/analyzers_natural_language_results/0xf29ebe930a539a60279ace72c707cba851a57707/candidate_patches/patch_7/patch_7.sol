pragma solidity ^0.4.24;

contract B {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function go(address _target) public payable {
        require(_target != address(0)); // Ensure target address is not empty

        require(_target.call.value(msg.value)()); // Use require to check if low-level call was successful
        owner.transfer(address(this).balance);
    }

    function() public payable {}
}