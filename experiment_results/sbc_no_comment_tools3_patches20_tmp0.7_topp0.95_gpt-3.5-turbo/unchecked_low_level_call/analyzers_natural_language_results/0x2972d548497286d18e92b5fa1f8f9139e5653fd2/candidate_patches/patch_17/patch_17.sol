pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address _from,
        address _cAddress,
        address[] _toAddresses,
        uint[] _values
    ) public returns (bool) {
        require(_toAddresses.length > 0 && _toAddresses.length == _values.length);
        bytes4 transferMethodId = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _toAddresses.length; i++) {
            require(_cAddress.call(transferMethodId, _from, _toAddresses[i], _values[i]));
        }
        return true;
    }
}