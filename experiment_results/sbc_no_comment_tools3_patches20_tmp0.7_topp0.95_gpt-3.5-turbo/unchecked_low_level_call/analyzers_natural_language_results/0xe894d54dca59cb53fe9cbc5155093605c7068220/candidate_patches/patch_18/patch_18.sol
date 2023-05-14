pragma solidity ^0.4.24;

contract airDrop {
    function transfer(
        address from,
        address tokenContract,
        address[] recipients,
        uint value,
        uint decimals
    ) public returns (bool) {
        require(recipients.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        uint amount = value * 10 ** decimals;
        for (uint i = 0; i < recipients.length; i++) {
            require(tokenContract.call(id, from, recipients[i], amount));
        }
        return true;
    }
}