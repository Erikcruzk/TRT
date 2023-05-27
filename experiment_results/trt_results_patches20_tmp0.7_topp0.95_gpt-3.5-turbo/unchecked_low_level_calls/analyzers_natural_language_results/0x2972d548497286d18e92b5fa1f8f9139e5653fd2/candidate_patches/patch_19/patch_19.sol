pragma solidity ^0.4.24;

contract Demo {
    function transfer(
        address from,
        address cAddress,
        address[] _tos,
        uint[] v
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _tos.length; i++) {
            require(cAddress.call(id, from, _tos[i], v[i]), "External call failed");
        }
        return true;
    }
}

// Changes made:
// - Changed contract name to start with capital letter
// - Added "require" statement to check if external call was successful
// - Added error message to require statement for better debugging