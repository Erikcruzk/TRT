pragma solidity ^0.8.0;

contract Reentrancy_secure {
    mapping(address => uint) private userBalances;
    bool private locked;

    function withdrawBalance() public {
        require(!locked, "Withdraw is locked");
        uint amountToWithdraw = userBalances[msg.sender];
        require(amountToWithdraw > 0, "No balance to withdraw");
        
        locked = true;
        (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
        require(success, "Transfer failed");
        userBalances[msg.sender] = 0;
        locked = false;
    }
    
    function depositBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }
    
    function getUserBalance() public view returns (uint) {
        return userBalances[msg.sender];
    }
}