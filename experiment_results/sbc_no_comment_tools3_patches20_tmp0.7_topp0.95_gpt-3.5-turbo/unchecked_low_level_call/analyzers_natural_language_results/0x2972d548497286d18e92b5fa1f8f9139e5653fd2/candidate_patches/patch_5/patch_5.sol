pragma solidity ^0.4.0;

contract Demo {
    function transfer(
        address from,
        address tokenContract,
        address[] _tos,
        uint[] values
    ) public returns (bool) {
        require(_tos.length > 0 && _tos.length == values.length);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(tokenContract.call(id, from, _tos[i], values[i]));
        }
        return true;
    }
}