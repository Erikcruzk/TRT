pragma solidity ^0.8.0;

contract Phishable {
    address payable public owner;

    constructor(address payable _owner) {
        owner = _owner;
    }

    receive() external payable {}

    function withdrawAll(address payable _recipient) public {
        require(msg.sender == owner);
        _recipient.transfer(address(this).balance);
    }
} 

// Changes made:
// 1. Made owner address payable.
// 2. Updated function to receive() instead of fallback function.
// 3. Changed tx.origin to msg.sender for better security.
// 4. Updated deprecated this.balance to address(this).balance.
// 5. Added payable modifier to recipient address for transfer function.