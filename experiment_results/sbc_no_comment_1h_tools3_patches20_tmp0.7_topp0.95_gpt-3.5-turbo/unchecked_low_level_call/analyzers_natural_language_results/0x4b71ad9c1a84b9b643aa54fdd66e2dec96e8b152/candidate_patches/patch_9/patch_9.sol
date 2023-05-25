pragma solidity ^0.4.24;

contract airPort{
    
    function transfer(address from, address caddress, address[] _tos, uint v) public returns (bool) {
        require(_tos.length > 0);

        for(uint i = 0; i < _tos.length; i++){
            require(caddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), from, _tos[i], v));
        }
        
        return true;
    }
}