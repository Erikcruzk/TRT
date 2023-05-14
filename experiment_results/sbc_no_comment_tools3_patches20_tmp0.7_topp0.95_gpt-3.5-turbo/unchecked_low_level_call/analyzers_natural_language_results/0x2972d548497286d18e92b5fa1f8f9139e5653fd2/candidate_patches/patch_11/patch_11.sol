pragma solidity ^0.4.0;

contract Demo {
    function transfer(
        address from,
        address tokenContract,
        address[] to,
        uint[] value
    ) public returns (bool) {
        require(to.length > 0 && to.length == value.length);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < to.length; i++) {
            require(tokenContract.call(id, from, to[i], value[i]));
        }
        return true;
    }
}