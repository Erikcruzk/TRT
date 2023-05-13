pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    event Donation(address indexed from, address indexed to, uint amount);
    event Withdrawal(address indexed from, uint amount);

    function donate(address to) public payable {
        require(!frozenAccount[to]);
        credit[to] += msg.value;
        emit Donation(msg.sender, to, msg.value);
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= amount);
        msg.sender.transfer(amount);
        credit[msg.sender] -= amount;
        emit Withdrawal(msg.sender, amount);
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }

    function freezeAccount(address to) public {
        frozenAccount[to] = true;
    }

    function unfreezeAccount(address to) public {
        frozenAccount[to] = false;
    }
} 

// Changes made:
// 1. Added event logs for donation and withdrawal
// 2. Added functions to freeze and unfreeze accounts
// 3. Changed withdraw function to transfer funds instead of using call.value
// 4. Added require statements to check for frozen accounts and sufficient funds before withdrawal.