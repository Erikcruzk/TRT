pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address _to) public payable {
        credit[_to] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(credit[msg.sender] >= _amount);
        credit[msg.sender] -= _amount;
        bool res = msg.sender.call.value(_amount)();
    }

    function queryCredit(address _to) public view returns (uint) {
        return credit[_to];
    }
}

// Changes made:
// - Added visibility modifiers to functions
// - Changed function parameter names to avoid shadowing
// - Reordered code to enforce checks before state changes
// - Added require statement to check for sufficient credit before withdrawing
// - Moved state change before external call in withdraw function to prevent reentrancy vulnerability