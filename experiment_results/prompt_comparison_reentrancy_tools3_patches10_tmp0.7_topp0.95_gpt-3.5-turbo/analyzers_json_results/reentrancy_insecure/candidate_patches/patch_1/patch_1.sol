pragma solidity ^0.4.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    mapping(address => bool) private locked;

    function withdrawBalance() public {
        require(!locked[msg.sender]);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked[msg.sender] = true;

        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);

        locked[msg.sender] = false;
    }
}