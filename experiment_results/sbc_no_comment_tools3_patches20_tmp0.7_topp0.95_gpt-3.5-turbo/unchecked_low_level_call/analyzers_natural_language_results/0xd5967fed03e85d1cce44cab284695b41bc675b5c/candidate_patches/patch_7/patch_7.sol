pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address _from,
        address _tokenAddress,
        address[] _to,
        uint256 _value
    ) public returns (bool) {
        require(_to.length > 0);
        bytes4 transferFunctionSelector = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint256 i = 0; i < _to.length; i++) {
            require(_to[i] != address(0)); // check if recipient address is valid
            bool success = _tokenAddress.call(transferFunctionSelector, _from, _to[i], _value);
            require(success); // check if token transfer was successful
        }
        return true;
    }
}