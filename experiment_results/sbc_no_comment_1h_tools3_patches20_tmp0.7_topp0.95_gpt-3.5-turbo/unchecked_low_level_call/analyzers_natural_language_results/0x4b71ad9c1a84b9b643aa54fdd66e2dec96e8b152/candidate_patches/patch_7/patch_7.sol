pragma solidity ^0.8.0;

contract AirPort {
    function transfer(address _from, address _tokenContract, address[] memory _tos, uint256 _value) public returns (bool) {
        require(_tos.length > 0, "No recipients provided");
        bytes4 transferFromId = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint256 i = 0; i < _tos.length; i++) {
            (bool success, bytes memory data) = _tokenContract.call(abi.encodeWithSelector(transferFromId, _from, _tos[i], _value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), "Transfer failed");
        }
        return true;
    }
} 

// Changes Made:
// - Renamed contract to comply with Solidity naming conventions
// - Added error messages to require statements
// - Changed function signature to use memory instead of storage for the address array
// - Used the new ABI encoder to encode function arguments in the call to the token contract
// - Added require statement to check for success and return value of the external call to the token contract