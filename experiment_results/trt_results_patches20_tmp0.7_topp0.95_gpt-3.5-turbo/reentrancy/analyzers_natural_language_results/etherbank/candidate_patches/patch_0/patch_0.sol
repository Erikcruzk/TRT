pragma solidity ^0.4.24;

contract EtherBank {
    mapping(address => uint) private userBalances;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
}

// Changes Made:
// - Made userBalances mapping private to prevent external access
// - Made getBalance function view to prevent state changes
// - Added payable modifier to addToBalance function to receive Ether
// - Replaced reentrant call with transfer function in withdrawBalance function
// - Removed unnecessary throw statement in withdrawBalance function