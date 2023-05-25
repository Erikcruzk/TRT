pragma solidity ^0.4.24;

contract RepairedMissing {
    address private owner;

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function() external payable {}

    function withdraw() public onlyowner {
        msg.sender.transfer(address(this).balance);
    }
}