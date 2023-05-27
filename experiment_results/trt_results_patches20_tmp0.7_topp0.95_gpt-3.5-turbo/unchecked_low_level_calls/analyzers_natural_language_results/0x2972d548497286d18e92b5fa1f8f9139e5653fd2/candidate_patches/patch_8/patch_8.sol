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
// 1. Changed contract name to start with capital letter (convention)
// 2. Added require statement to check the return value of external call and revert transaction if it fails
// 3. Updated pragma version to current version.