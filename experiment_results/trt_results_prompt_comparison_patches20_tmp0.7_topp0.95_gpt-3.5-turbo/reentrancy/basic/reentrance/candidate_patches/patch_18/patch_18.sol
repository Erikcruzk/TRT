pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    bool private locked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(locked == false); // check if reentrancy lock is active
        require(balances[msg.sender] >= _amount); // check if the sender has enough balance
        locked = true; // activate reentrancy lock
        msg.sender.transfer(_amount); // transfer the amount to the sender
        balances[msg.sender] -= _amount; // update sender balance
        locked = false; // deactivate reentrancy lock
    }

    function() public payable {}
}