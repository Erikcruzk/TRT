pragma solidity ^0.4.24;

contract airDrop {
    function transfer(
        address tokenAddress,
        address[] recipients,
        uint amount
    ) public returns (bool) {
        require(recipients.length > 0);
        for (uint i = 0; i < recipients.length; i++) {
            require(tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), recipients[i], amount));
        }
        return true;
    }
}