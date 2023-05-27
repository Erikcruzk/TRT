pragma solidity ^0.4.24;

contract airPort{
    
    function transfer(address from, address caddress, address[] _tos, uint256 v) public returns (bool){
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i=0; i<_tos.length; i++){
            require(caddress.call(id, from, _tos[i], v), "External call failed");
        }
        return true;
    }
} 

// Changes Made:
// - Added uint256 to parameter v in function transfer to specify the data type
// - Added require statement to check the return value of the external call
// - Added error message to require statement for better debugging