pragma solidity ^0.4.18;

contract Reentrance {
    mapping(address => uint) public balances;
    bool locked;

    function donate(address _to) public payable {
        balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint balance) {
        return balances[_who];
    }

    function withdraw(uint _amount) public {
        require(!locked);
        locked = true;
        if(balances[msg.sender] >= _amount) {
            balances[msg.sender] -= _amount;
            if(!msg.sender.call.value(_amount)()) {
                revert();
            }
        }
        locked = false;
    }

    function() public payable {}
} 

// In the repaired contract, a locked boolean variable has been added to prevent reentrancy attack. We have used require to check if it is locked or not. In case of re-entrancy attack, the function will revert. We have also modified the order of statements in withdraw function.