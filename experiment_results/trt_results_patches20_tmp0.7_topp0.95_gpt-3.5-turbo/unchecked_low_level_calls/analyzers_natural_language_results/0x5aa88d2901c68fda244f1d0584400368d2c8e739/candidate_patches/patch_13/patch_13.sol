pragma solidity ^0.4.18;

contract MultiplicatorX3 {
    address public owner = msg.sender;

    function() public payable {}

    function withdraw() public {
        require(msg.sender == owner);
        owner.transfer(this.balance);
    }

    function command(address _to, bytes _data) public payable {
        require(msg.sender == owner);
        require(_to != address(0));

        bool success;
        bytes memory returnedData;

        assembly {
            let size := mload(_data)
            let ptr := add(_data, 0x20)
            success := call(gas, _to, msg.value, ptr, size, 0, 0)
            let len := returndatasize
            returnedData := mload(0x40)
            mstore(returnedData, len)
            returndatacopy(add(returnedData, 0x20), 0, len)
        }

        require(success);
    }

    function multiplicate(address _to) public payable {
        require(_to != address(0));
        require(msg.value > 0);
        
        uint256 balanceBefore = this.balance;
        _to.transfer(msg.value);
        uint256 balanceAfter = this.balance;

        assert(balanceAfter == balanceBefore - msg.value);
    }
}