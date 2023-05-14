pragma solidity ^0.4.15;

contract Overflow {
    uint256 private sellerBalance = 0;

    function add(uint256 value) public returns (bool) {
        require(value + sellerBalance >= sellerBalance); // check for overflow
        sellerBalance += value;
        return true;
    }

    function getBalance() public view returns (uint256) {
        return sellerBalance;
    }
}