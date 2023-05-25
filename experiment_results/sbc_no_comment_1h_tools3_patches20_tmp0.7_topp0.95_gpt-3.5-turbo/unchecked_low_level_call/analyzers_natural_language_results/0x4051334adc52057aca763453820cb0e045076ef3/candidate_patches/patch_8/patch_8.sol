pragma solidity ^0.4.24;

contract airdrop {
    function transfer(
        address token,
        address[] _tos,
        uint256 amount
    ) public returns (bool) {
        require(_tos.length > 0);
        for (uint256 i = 0; i < _tos.length; i++) {
            require(token.call(bytes4(keccak256("transfer(address,uint256)")), _tos[i], amount));
        }
        return true;
    }
}