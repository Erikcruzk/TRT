pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address _from,
        address _cAddress,
        address[] _tos,
        uint256 _value
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 methodId = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(_cAddress.call(methodId, _from, _tos[i], _value));
        }
        return true;
    }
}