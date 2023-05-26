pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;

    event Donation(address indexed to, uint value);
    event Withdrawal(address indexed from, uint value);

    function donate(address _to) public payable {
        require(!frozenAccount[_to], "Account is frozen");
        credit[_to] += msg.value;
        emit Donation(_to, msg.value);
    }

    function withdraw(uint _amount) public {
        require(!frozenAccount[msg.sender], "Account is frozen");
        require(credit[msg.sender] >= _amount, "Insufficient balance");
        credit[msg.sender] -= _amount;
        emit Withdrawal(msg.sender, _amount);
        bool success = msg.sender.send(_amount);
        require(success, "Withdrawal failed");
    }

    function queryCredit(address _to) public view returns (uint) {
        return credit[_to];
    }

    function freezeAccount(address _to) public {
        require(msg.sender == address(0x123), "Only owner can freeze accounts");
        frozenAccount[_to] = true;
    }

    function unfreezeAccount(address _to) public {
        require(msg.sender == address(0x123), "Only owner can unfreeze accounts");
        frozenAccount[_to] = false;
    }
}