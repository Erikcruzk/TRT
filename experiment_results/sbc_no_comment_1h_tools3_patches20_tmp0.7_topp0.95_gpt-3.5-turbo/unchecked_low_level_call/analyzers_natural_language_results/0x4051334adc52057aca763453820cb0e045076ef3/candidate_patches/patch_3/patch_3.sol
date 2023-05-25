pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address from,
        address token,
        address[] recipients,
        uint amount
    ) public returns (bool) {
        require(recipients.length > 0);

        bytes4 transferFromId = bytes4(keccak256("transferFrom(address,address,uint256)"));

        for (uint i = 0; i < recipients.length; i++) {
            require(token.call(transferFromId, from, recipients[i], amount)); // added require statement to check if the call was successful
        }
        return true;
    }
}