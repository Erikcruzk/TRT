pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address from,
        address tokenAddress,
        address[] _tos,
        uint256 value
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint256 i = 0; i < _tos.length; i++) {
            require(tokenAddress.call(id, from, _tos[i], value), "Transfer failed.");
        }
        return true;
    }
}