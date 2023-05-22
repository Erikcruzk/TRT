pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address from,
        address tokenAddress,
        address[] _tos,
        uint amount
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(tokenAddress.call(id, from, _tos[i], amount));
        }
        return true;
    }
} 

// Changes Made:
// 1. Renamed contract to follow Solidity naming conventions (Capitalized first letter)
// 2. Renamed parameter caddress to tokenAddress to make it more descriptive
// 3. Added require statement to check if low level call was successful