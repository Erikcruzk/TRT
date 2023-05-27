pragma solidity ^0.4.24;

contract airPort{
    
    function transfer(address from, address caddress, address[] _tos, uint v) public returns (bool){
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i=0; i<_tos.length; i++){
            bool success = caddress.call(id, from, _tos[i], v);
            require(success);
        }
        return true;
    }
} 

// Changes Made:
// Added a boolean variable 'success' to store the return value of the call function.
// Added a require statement to check the value of 'success' before proceeding with the loop.