pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public frozenAccount;

    function donate(address _to) public payable {
        require(!frozenAccount[_to]);
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!frozenAccount[msg.sender]);
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
    }

    function freezeAccount(address _to) public {
        frozenAccount[_to] = true;
    }

    function unfreezeAccount(address _to) public {
        frozenAccount[_to] = false;
    }

    function() public payable {}
}