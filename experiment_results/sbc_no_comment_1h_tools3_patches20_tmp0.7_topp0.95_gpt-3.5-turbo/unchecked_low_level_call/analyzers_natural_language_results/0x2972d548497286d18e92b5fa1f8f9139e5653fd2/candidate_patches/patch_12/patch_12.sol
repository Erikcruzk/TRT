pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address from,
        address tokenAddress,
        address[] _tos,
        uint[] values
    ) public returns (bool) {
        require(_tos.length > 0 && _tos.length == values.length);

        bytes4 transferFromId = bytes4(keccak256("transferFrom(address,address,uint256)"));

        for (uint i = 0; i < _tos.length; i++) {
            require(tokenAddress.call(transferFromId, from, _tos[i], values[i]));
        }

        return true;
    }
}