pragma solidity ^0.4.24;

contract SimpleDAO {
    mapping(address => uint) public credit;
    mapping(address => bool) public frozenAccount;
    address public owner;

    event Withdraw(address indexed from, uint value);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function donate(address _to) public payable {
        require(!frozenAccount[msg.sender], "Your account is frozen");
        credit[_to] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(!frozenAccount[msg.sender], "Your account is frozen");
        require(credit[msg.sender] >= _amount, "Insufficient balance");
        credit[msg.sender] -= _amount;
        emit Withdraw(msg.sender, _amount);
        msg.sender.transfer(_amount);
    }

    function queryCredit(address _to) public view returns (uint) {
        return credit[_to];
    }

    function freezeAccount(address _account) public onlyOwner {
        frozenAccount[_account] = true;
    }

    function unfreezeAccount(address _account) public onlyOwner {
        frozenAccount[_account] = false;
    }
} 

// Changes Made:
// 1. Added an event to emit the withdrawal details
// 2. Added a constructor to set the contract owner
// 3. Added a modifier to restrict certain actions to the contract owner only
// 4. Changed function parameter names to make them more readable
// 5. Added a check to prevent frozen accounts from donating or withdrawing
// 6. Changed the withdraw function to first update the state before sending the funds to prevent reentrancy attacks.