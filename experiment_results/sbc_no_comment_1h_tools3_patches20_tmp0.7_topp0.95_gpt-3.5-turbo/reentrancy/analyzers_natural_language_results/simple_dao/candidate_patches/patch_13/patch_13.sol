pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public locked;

    function donate(address to) public payable {
        credit[to] += msg.value;
    }

    function withdraw(uint amount) public {
        require(!locked[msg.sender]);
        require(credit[msg.sender] >= amount);
        locked[msg.sender] = true;
        msg.sender.transfer(amount);
        credit[msg.sender] -= amount;
        locked[msg.sender] = false;
    }

    function queryCredit(address to) public view returns (uint) {
        return credit[to];
    }
} 

// The repaired contract adds a reentrancy lock to the withdraw function, preventing reentrancy attacks. It also includes a require statement to check if the sender has sufficient funds before allowing a withdrawal. Additionally, it uses the transfer() function to send the funds instead of the call.value() function, reducing the risk of reentrancy attacks. Finally, it adds the "public" visibility modifier to all functions for clarity.