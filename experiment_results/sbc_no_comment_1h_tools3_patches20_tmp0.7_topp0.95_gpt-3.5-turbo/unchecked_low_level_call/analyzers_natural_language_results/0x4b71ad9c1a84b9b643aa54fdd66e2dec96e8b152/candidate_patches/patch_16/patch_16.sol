pragma solidity ^0.4.24;

contract airPort {
    function transfer(address from, address caddress, address[] _tos, uint v) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(caddress.call(id, from, _tos[i], v), "Low level call failed");
        }
        return true;
    }
} 

// Changes Made:
// - Added require statement to check the return value of the low-level call
// - Added error message to require statement to indicate low-level call failure.