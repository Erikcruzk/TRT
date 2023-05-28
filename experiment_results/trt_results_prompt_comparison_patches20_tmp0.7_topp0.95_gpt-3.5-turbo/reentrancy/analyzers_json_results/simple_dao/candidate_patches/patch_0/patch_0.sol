pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint256) public credit;
    mapping(address => bool) public frozenAccount;

    event LogDonation(address indexed donor, uint256 value);
    event LogWithdrawal(address indexed receiver, uint256 value);

    function donate(address _to) public payable {
        require(!frozenAccount[_to]);
        credit[_to] += msg.value;
        emit LogDonation(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        require(!frozenAccount[msg.sender]);
        require(credit[msg.sender] >= _amount);
        credit[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
        emit LogWithdrawal(msg.sender, _amount);
    }

    function queryCredit(address _to) public view returns (uint256) {
        return credit[_to];
    }

    function freezeAccount(address _account) public {
        frozenAccount[_account] = true;
    }

    function unfreezeAccount(address _account) public {
        frozenAccount[_account] = false;
    }
}