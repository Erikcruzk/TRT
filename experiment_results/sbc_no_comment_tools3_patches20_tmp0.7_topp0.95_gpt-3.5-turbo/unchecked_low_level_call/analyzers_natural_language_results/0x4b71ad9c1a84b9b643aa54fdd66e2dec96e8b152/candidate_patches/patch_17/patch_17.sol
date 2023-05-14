pragma solidity ^0.4.24;

contract AirPort {
    function transfer(address _from, address _tokenContract, address[] _tos, uint256 _value) public returns (bool) {
        require(_tos.length > 0);

        bytes4 transferFromSelector = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint256 i = 0; i < _tos.length; i++) {
            require(_tokenContract.call(transferFromSelector, _from, _tos[i], _value));
        }

        return true;
    }
} 

// Changes Made:
// 1. Renamed contract name to follow Solidity naming convention.
// 2. Added parameter names to the function signature.
// 3. Used require to check if _tokenContract.call() is successful.
// 4. Changed variable names to be more descriptive.