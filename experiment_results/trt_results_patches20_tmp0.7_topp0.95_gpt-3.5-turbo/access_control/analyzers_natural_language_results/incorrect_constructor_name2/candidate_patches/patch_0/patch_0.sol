pragma solidity ^0.8.0;

contract Missing {
    address payable private owner;

    modifier onlyowner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function withdraw() public onlyowner {
        require(address(this).balance > 0, "Contract balance is zero");
        owner.transfer(address(this).balance);
    }
}