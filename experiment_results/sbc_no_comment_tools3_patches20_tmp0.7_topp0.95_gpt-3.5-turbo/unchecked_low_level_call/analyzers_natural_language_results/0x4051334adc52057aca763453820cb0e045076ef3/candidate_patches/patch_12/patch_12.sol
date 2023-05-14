pragma solidity ^0.4.24;

contract Airdrop {
    function transfer(
        address from,
        address tokenAddress,
        address[] toAddresses,
        uint amount
    ) public returns (bool) {
        require(toAddresses.length > 0);
        bytes4 id = bytes4(keccak256("transferFrom(address,address,uint256)"));
        for (uint i = 0; i < toAddresses.length; i++) {
            require(tokenAddress.call(id, from, toAddresses[i], amount));
        }
        return true;
    }
}