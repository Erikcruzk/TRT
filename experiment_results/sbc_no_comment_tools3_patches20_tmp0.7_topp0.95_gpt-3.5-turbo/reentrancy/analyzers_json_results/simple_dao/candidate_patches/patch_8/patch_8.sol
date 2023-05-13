pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address _to) public payable {
        credit[_to] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(credit[msg.sender] >= _amount);
        credit[msg.sender] -= _amount;
        msg.sender.transfer(_amount);
    }

    function queryCredit(address _to) public view returns (uint) {
        return credit[_to];
    }
} 

// Changes made:
// - Updated Solidity version to ^0.4.24
// - Added "public" visibility to functions
// - Changed function parameter names to use "_" prefix for consistency
// - Added "require" statement to check if the sender has enough credit to withdraw
// - Removed "bool res =" and replaced with "msg.sender.transfer(_amount)" to prevent reentrancy vulnerability
// - Added "view" modifier to queryCredit function to indicate it does not modify state