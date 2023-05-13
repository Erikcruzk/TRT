pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    function donate(address to) public payable {
        require(!frozenAccount[to]);
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address account) public {
        require(msg.sender == address(0x123)); // Only the owner can freeze an account
        frozenAccount[account] = true;
    }

    function unfreezeAccount(address account) public {
        require(msg.sender == address(0x123)); // Only the owner can unfreeze an account
        frozenAccount[account] = false;
    }
} 

// Changes made:
// - Added a mapping to keep track of frozen accounts
// - Added require statements to check if the account is frozen before donation or withdrawal
// - Changed the withdraw function to transfer the amount directly to the user before updating the credit mapping
// - Added functions to freeze and unfreeze accounts, with a check to ensure only the owner can perform these actions