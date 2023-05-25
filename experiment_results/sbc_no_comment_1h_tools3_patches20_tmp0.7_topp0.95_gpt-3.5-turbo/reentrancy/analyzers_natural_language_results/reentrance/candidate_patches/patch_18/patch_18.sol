pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    mapping(address => bool) public lock;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!lock[msg.sender]);
        require(balances[msg.sender] >= _amount);
        lock[msg.sender] = true;
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        lock[msg.sender] = false;
    }

    function() public payable {}
}

// Changes Made:
// - Added a lock mapping to prevent reentrancy attacks
// - Replaced the external call with transfer to prevent reentrancy attacks
// - Added require statements to check if the caller has enough balance and is not already in a lock state