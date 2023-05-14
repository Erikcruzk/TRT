pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address token,
        address from,
        address[] _tos,
        uint value
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(token.call(id, from, _tos[i], value)); // added require statement to check return value
        }
        return true;
    }
}