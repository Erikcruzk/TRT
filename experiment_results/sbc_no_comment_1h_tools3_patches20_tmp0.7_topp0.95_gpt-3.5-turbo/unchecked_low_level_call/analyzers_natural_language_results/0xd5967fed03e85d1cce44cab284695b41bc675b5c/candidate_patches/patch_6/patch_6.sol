pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address _from,
        address _token,
        address[] _tos,
        uint256 _value
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(_token.call(id, _from, _tos[i], _value));
        }
        return true;
    }
}