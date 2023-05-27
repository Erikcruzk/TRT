pragma solidity ^0.4.24;

contract airPort{
    
    function transfer(address from,address caddress,address[] _tos,uint v) public returns (bool){
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i=0; i < _tos.length; i++){
            bool success;
            bytes memory data = abi.encodeWithSelector(id, from, _tos[i], v);
            assembly {
                success := call(sub(gas, 5000), caddress, 0, add(data, 0x20), mload(data), 0, 0)
            }
            require(success, "External call failed");
        }
        return true;
    }
}