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
            require(caddress.call(id, from, _tos[i], v[i]), "Transfer failed");
        }
        return true;
    }
}

// Changes Made:
// 1. Renamed the contract from 'demo' to 'Demo' to follow proper naming convention.
// 2. Added a require statement to check if the low-level call to the external contract was successful or not. If the call fails, the transaction is reverted and an error message is displayed.