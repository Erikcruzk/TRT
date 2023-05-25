pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address from,
        address tokenAddress,
        address[] _tos,
        uint amount
    ) public returns (bool) {
        require(_tos.length > 0 && amount > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(tokenAddress.call(id, from, _tos[i], amount));
        }
        return true;
    }
}

// Changes made:
// - Renamed contract to start with uppercase letter
// - Renamed variable names for clarity
// - Added require statement to check that amount and _tos.length are greater than 0
// - Added require statement to check the return value of the tokenAddress.call() function call