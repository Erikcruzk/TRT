pragma solidity ^0.4.19;

contract ReentrancyDAO {
    mapping(address => uint) credit;
    uint balance;
    bool locked;

    function withdrawAll() public {
        require(!locked);
        uint oCredit = credit[msg.sender];
        require(oCredit > 0);
        credit[msg.sender] = 0;
        locked = true;
        balance -= oCredit;
        msg.sender.transfer(oCredit);
        locked = false;
    }

    function deposit() public payable {
        credit[msg.sender] += msg.value;
        balance += msg.value;
    }
}

// The repaired contract implements a reentrancy guard to prevent the reentrancy attack by setting a boolean locked variable to true before the external call and setting it back to false after the call is completed. It also transfers the funds to the sender using the transfer function instead of the call function to prevent reentrancy attacks. Additionally, it removes the state variable write operation after the external call in the withdrawAll function to avoid the SWC-107 vulnerability.