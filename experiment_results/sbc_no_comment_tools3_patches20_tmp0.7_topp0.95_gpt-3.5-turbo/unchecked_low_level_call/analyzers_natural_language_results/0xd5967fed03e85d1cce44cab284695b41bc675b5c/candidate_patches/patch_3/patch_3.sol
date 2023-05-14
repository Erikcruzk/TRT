pragma solidity ^0.4.0;

contract Demo {
    function transfer(
        address _from,
        address _tokenContractAddress,
        address[] _to,
        uint256 _value
    ) public returns (bool) {
        require(_to.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint256 i = 0; i < _to.length; i++) {
            require(_tokenContractAddress.call(id, _from, _to[i], _value));
        }
        return true;
    }
}