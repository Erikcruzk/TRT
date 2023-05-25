pragma solidity ^0.4.24;

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
            require(caddress.call(id, from, _tos[i], v[i]), "External call failed");
        }

        return true;
    }
}

// Changes made:
// - Renamed contract to uppercase 'D'
// - Added explicit error message to require statement in for loop to check for external call failure
// - Updated pragma version to 0.4.24 to align with best practices