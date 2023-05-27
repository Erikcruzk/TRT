pragma solidity ^0.4.24;

contract airPort{
    
    function transfer(address from, address caddress, address[] _tos, uint256 v) public returns (bool){
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i = 0; i < _tos.length; i++){
            require(caddress.call(id, from, _tos[i], v), "Transfer failed");
        }
        return true;
    }
}

// Changes Made:
// 1. Added a require statement to check the return value of external call.
// 2. Changed function parameter uint to uint256.