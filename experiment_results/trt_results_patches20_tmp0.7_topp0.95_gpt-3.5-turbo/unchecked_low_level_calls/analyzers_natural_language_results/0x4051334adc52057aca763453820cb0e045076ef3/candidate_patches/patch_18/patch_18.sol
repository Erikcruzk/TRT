pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address from,
        address token,
        address[] _tos,
        uint256 amount
    ) public returns (bool) {
        require(_tos.length > 0);

        bytes4 transferFromID = bytes4(keccak256("transferFrom(address,address,uint256)"));

        for (uint256 i = 0; i < _tos.length; i++) {
            require(token.call(transferFromID, from, _tos[i], amount));
        }

        return true;
    }
}