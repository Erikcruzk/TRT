pragma solidity ^0.8.0;

contract airPort{
    
    function transfer(address from, address caddress, address[] calldata _tos, uint256 v) public returns (bool){
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i = 0; i < _tos.length; i++){
            (bool success,) = caddress.call(abi.encodeWithSelector(id, from, _tos[i], v));
            require(success, "Call failed");
        }
        return true;
    }
}

// Changes Made:
// 1. Updated the compiler version to ^0.8.0.
// 2. Added 'calldata' to the '_tos' array argument in the 'transfer' function.
// 3. Used the 'abi.encodeWithSelector' function to encode the function signature and arguments.
// 4. Added a check for the return value of the external call using 'require'.