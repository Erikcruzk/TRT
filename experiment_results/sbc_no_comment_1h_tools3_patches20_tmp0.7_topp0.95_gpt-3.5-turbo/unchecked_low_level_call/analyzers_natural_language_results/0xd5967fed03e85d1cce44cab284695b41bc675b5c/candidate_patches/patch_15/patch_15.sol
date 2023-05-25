pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address from,
        address tokenAddress,
        address[] _tos,
        uint256 amount
    ) public returns (bool) {
        require(_tos.length > 0, "At least one recipient address required");
        bytes4 transferFromSig = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint256 i = 0; i < _tos.length; i++) {
            require(tokenAddress.call(transferFromSig, from, _tos[i], amount), "Token transfer failed");
        }
        return true;
    }
}