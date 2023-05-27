pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _addr, bytes _data) public payable {
        require(msg.sender == owner);
        require(_addr != address(0)); // Added check for valid address

        bool success;
        bytes memory returnData;

        assembly { // Wrapped low-level call in assembly and added check for success
            let ptr := mload(0x40)
            let size := mload(_data)
            success := call(gas, _addr, msg.value, add(_data, 0x20), size, ptr, 0)
            returnData := ptr
            mstore(0x40, add(ptr, returndatasize))
        }

        require(success); // Added require for successful call
    }

    function multiply(address _addr) public payable {
        require(_addr != address(0)); // Added check for valid address
        require(msg.value > 0); // Added check for non-zero value

        uint256 balanceBefore = this.balance;
        require(_addr.call.value(msg.value)()); // Wrapped low-level call and added require for successful call
        uint256 balanceAfter = this.balance;

        require(balanceAfter >= balanceBefore); // Added require for increased contract balance
    }
}