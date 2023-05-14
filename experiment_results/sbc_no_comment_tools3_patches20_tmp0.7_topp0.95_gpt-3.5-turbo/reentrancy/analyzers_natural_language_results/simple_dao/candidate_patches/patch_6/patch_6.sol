pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    event Donation(address indexed donor, address indexed receiver, uint amount);
    event Withdrawal(address indexed receiver, uint amount);

    function donate(address receiver) payable public {
        require(!frozenAccount[msg.sender], "Your account is frozen.");
        credit[receiver] += msg.value;
        emit Donation(msg.sender, receiver, msg.value);
    }

    function withdraw(uint amount) public {
        require(!frozenAccount[msg.sender], "Your account is frozen.");
        require(credit[msg.sender] >= amount, "Insufficient funds.");
        credit[msg.sender] -= amount;
        msg.sender.transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function queryCredit(address receiver) public view returns (uint) {
        return credit[receiver];
    }

    function freezeAccount(address account) public {
        require(msg.sender == address(0x123), "Only the owner can freeze an account.");
        frozenAccount[account] = true;
    }

    function unfreezeAccount(address account) public {
        require(msg.sender == address(0x123), "Only the owner can unfreeze an account.");
        frozenAccount[account] = false;
    }
}