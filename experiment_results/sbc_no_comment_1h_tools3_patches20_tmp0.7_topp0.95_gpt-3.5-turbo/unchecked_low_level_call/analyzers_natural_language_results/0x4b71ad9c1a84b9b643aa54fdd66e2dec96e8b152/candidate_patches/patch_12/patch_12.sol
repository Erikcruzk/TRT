pragma solidity ^0.8.0;

contract AirPort{
    
    function transfer(address from, address caddress, address[] memory _tos, uint256 v) public returns (bool){
        require(_tos.length > 0, "At least one destination address should be provided.");
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i = 0; i < _tos.length; i++){
            bool success;
            bytes memory result;
            (success, result) = caddress.call(abi.encodeWithSelector(id, from, _tos[i], v));
            require(success, "Call to transferFrom function failed.");
        }
        return true;
    }
}