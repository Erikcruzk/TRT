pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(credit[msg.sender] >= amount); // added require statement
        credit[msg.sender] -= amount;
        bool res = msg.sender.call.value(amount)(); // moved external call to the end
        require(res); // added require statement
    }

    function queryCredit(address to) public view returns (uint) { // added view keyword
        return credit[to];
    }
} 

// Changes Made:
// 1. Added 'require' statement to check that the user has enough credit to withdraw the requested amount.
// 2. Moved the external call to the end of the function, after the state variable modification.
// 3. Added 'require' statement to check the success of the external call.
// 4. Added 'view' keyword to the queryCredit function to indicate it does not modify the state.