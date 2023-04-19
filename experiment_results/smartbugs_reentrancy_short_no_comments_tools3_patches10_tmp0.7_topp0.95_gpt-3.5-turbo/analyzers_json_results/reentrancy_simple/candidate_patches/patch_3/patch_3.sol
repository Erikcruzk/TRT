pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;

    function getBalance(address u) constant public returns(uint){
        return userBalance[u];
    }

    function addToBalance() payable public {
        require(msg.value > 0);
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalance[msg.sender];
        require(amountToWithdraw > 0);
        userBalance[msg.sender] = 0;
        if( !msg.sender.call.value(amountToWithdraw)() ){
            revert();
        }
    }
} 

// Changes made:
// 1. Added access modifiers to functions
// 2. Added input validation to addToBalance function
// 3. Stored the user balance in a local variable before setting it to zero
// 4. Reordered the code in withdrawBalance function to avoid reentrancy vulnerability
// 5. Changed 'throw' to 'revert' to conform to the latest Solidity version