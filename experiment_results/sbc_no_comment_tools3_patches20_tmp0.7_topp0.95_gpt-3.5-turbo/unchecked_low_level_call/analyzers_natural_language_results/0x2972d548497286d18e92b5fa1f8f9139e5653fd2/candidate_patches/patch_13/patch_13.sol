pragma solidity ^0.4.0;

contract Demo {
    function transfer(
        address from,
        address caddress,
        address[] _tos,
        uint[] v
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(caddress.call(id, from, _tos[i], v[i])); // added require statement to check for successful execution of low level call
        }
        return true;
    }
}