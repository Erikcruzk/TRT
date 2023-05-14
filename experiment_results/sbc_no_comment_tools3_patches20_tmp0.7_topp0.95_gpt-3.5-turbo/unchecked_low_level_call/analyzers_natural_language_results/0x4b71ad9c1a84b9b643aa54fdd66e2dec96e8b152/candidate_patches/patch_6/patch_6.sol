pragma solidity ^0.4.24;

contract airPort{
    
    function transfer(address _from,address _caddress,address[] _tos,uint _v) public returns (bool){
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i=0; i<_tos.length; i++){
            require(_caddress.call(id, _from, _tos[i], _v)); // Check the return value of the call
        }
        return true;
    }
}