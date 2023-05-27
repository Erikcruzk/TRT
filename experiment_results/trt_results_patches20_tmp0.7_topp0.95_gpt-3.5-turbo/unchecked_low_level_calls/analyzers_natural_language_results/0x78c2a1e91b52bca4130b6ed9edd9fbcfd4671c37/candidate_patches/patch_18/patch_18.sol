pragma solidity ^0.4.19;

contract WhaleGiveaway1 {
    address public owner;

    uint public constant minEligibility = 0.999001 ether;

    function WhaleGiveaway1() public {
        owner = msg.sender;
    }

    function() public payable {}

    function redeem() public payable {
        if (msg.value >= minEligibility) {
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() public payable {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _adr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_adr.call.value(msg.value)(_data));
    }
}

// Changes made:
// 1. Removed redundant Owner variable and replaced it with owner
// 2. Added constructor to initialize owner
// 3. Removed unnecessary transfer to Owner in redeem function
// 4. Checked return value of external call in command function
// 5. Made minor formatting changes for readability