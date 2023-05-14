pragma solidity ^0.4.0;

contract Demo {
    function transfer(
        address from,
        address tokenAddress,
        address[] toAddresses,
        uint[] values
    ) public returns (bool) {
        require(toAddresses.length > 0 && toAddresses.length == values.length);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < toAddresses.length; i++) {
            require(tokenAddress.call(id, from, toAddresses[i], values[i]));
        }
        return true;
    }
}