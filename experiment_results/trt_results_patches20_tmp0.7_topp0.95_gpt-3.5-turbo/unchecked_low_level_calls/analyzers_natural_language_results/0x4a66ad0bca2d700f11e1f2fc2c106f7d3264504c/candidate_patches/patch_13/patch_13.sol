pragma solidity ^0.4.18;

contract EBU {
    address public owner = 0x9797055B68C5DadDE6b3c7d5D80C9CFE2eecE6c9;
    address public tokenContract = 0x1f844685f7Bf86eFcc0e74D8642c54A257111923;

    function transfer(address[] _tos, uint[] _values) public returns (bool) {
        require(msg.sender == owner);
        require(_tos.length == _values.length && _tos.length > 0);

        for (uint i = 0; i < _tos.length; i++) {
            require(tokenContract.call(bytes4(keccak256("transferFrom(address,address,uint256)")), owner, _tos[i], _values[i] * 1 ether));
        }
        return true;
    }
}