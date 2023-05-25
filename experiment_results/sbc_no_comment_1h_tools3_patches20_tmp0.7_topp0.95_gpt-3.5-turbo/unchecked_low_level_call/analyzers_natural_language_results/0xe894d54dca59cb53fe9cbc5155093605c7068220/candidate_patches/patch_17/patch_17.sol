pragma solidity ^0.4.24;

contract AirDrop {
    function transfer(
        address from,
        address tokenContractAddress,
        address[] _tos,
        uint amount,
        uint decimals
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        uint value = amount * 10 ** decimals;
        for (uint i = 0; i < _tos.length; i++) {
            require(tokenContractAddress.call(id, from, _tos[i], value), "Transfer failed");
        }
        return true;
    }
}