pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Reentrancy protection");
        uint amountToWithdraw = userBalances[msg.sender];
        locked = true;
        userBalances[msg.sender] = 0;
        locked = false;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success);
    }
}