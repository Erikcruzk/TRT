pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address tokenAddress,
        address[] recipients,
        uint256 amount
    ) public returns (bool) {
        require(recipients.length > 0, "Recipients array must not be empty");
        bytes4 transferSig = bytes4(keccak256("transfer(address,uint256)"));
        for (uint256 i = 0; i < recipients.length; i++) {
            require(tokenAddress.call(transferSig, recipients[i], amount), "Token transfer failed");
        }
        return true;
    }
} 

// Changes made: 
// 1. Renamed the contract to follow Solidity naming conventions.
// 2. Changed the function parameters to be more intuitive and easier to understand.
// 3. Added a require statement to check that the recipients array is not empty.
// 4. Changed the token transfer function to use the transfer method instead of transferFrom to avoid potential security issues.
// 5. Added a require statement to check that the token transfer was successful.