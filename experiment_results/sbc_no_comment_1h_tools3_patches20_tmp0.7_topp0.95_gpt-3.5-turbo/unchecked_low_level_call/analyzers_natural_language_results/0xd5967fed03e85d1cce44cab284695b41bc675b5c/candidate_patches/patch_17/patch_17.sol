pragma solidity ^0.4.24;

contract Demo {
    function transfer(address _from, address _tokenContract, address[] _toAddresses, uint256 _value) public returns (bool) {
        require(_toAddresses.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < _toAddresses.length; i++) {
            require(_tokenContract.call(id, _from, _toAddresses[i], _value));
        }
        return true;
    }
}