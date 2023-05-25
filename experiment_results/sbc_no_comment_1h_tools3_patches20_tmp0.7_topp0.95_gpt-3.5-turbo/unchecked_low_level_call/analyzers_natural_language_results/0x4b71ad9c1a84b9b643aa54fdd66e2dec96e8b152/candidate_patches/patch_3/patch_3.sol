pragma solidity ^0.8.0;

contract airPort{
    
    function transfer(address from, address caddress, address[] memory _tos, uint256 v) public returns (bool){
        require(_tos.length > 0, "Array of addresses should not be empty.");
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i = 0; i < _tos.length; i++){
            bool success;
            bytes memory returnData;
            (success, returnData) = caddress.call(abi.encodeWithSelector(id, from, _tos[i], v));
            require(success, "External call failed.");
        }
        return true;
    }
}