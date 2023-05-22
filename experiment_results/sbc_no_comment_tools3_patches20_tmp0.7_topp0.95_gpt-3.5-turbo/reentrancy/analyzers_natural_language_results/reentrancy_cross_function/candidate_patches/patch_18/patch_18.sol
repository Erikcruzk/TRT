pragma solidity ^0.4.0;

contract Reentrancy_cross_function {
    mapping(address => uint) private userBalances;
    bool private locked;

    function transfer(address to, uint amount) public {
        require(!locked);
        if (userBalances[msg.sender] >= amount) {
            userBalances[to] += amount;
            userBalances[msg.sender] -= amount;
        }
    }

    function withdrawBalance() public {
        require(!locked);
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        locked = true;
        (bool success, ) = msg.sender.call.value(amountToWithdraw)("");
        require(success);
        locked = false;
    }
}