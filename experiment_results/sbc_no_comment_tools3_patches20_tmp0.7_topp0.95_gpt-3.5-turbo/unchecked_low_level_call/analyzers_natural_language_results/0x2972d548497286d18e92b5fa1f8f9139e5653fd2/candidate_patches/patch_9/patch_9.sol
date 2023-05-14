pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address from,
        address token,
        address[] tos,
        uint[] values
    ) public returns (bool) {
        require(tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < tos.length; i++) {
            require(token.call(id, from, tos[i], values[i]));
        }
        return true;
    }
}