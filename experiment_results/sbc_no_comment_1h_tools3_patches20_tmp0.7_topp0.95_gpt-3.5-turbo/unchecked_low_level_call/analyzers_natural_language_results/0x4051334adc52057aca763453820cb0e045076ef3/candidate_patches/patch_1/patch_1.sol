pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address token,
        address[] recipients,
        uint256 amount
    ) public returns (bool) {
        require(recipients.length > 0);

        for (uint256 i = 0; i < recipients.length; i++) {
            require(token.call(bytes4(keccak256("transfer(address,uint256)")), recipients[i], amount));
        }

        return true;
    }
}