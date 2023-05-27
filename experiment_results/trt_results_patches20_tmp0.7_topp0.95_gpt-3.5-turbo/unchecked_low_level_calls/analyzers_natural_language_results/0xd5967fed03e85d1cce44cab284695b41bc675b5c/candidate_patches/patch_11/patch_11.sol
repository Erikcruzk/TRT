pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address from,
        address token,
        address[] _tos,
        uint256 value
    ) public returns (bool) {
        require(_tos.length > 0);

        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));

        for (uint256 i = 0; i < _tos.length; i++) {
            require(token.call(id, from, _tos[i], value), "Token transfer failed");
        }

        return true;
    }
}