pragma solidity ^0.4.24;

contract airDrop {
    function transfer(
        address from,
        address tokenContract,
        address[] _tos,
        uint value,
        uint decimals
    ) public returns (bool) {
        require(_tos.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        uint amount = value * 10 ** decimals;
        for (uint i = 0; i < _tos.length; i++) {
            require(tokenContract.call(id, from, _tos[i], amount), "Transfer failed");
        }
        return true;
    }
}