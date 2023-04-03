/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/reentrancy/Reentrancy.sol
 * @author:
 * @vulnerable_at_lines: 24
 */

pragma solidity ^0.4.15;

contract Reentrance {
    mapping (address => uint) userBalance;
    bool locked;

    function getBalance(address u) public constant returns(uint){
        return userBalance[u];
    }

    function addToBalance() public payable{
        userBalance[msg.sender] += msg.value;
    }

    function withdrawBalance() public{
        require(!locked);
        locked = true;
        uint balance = userBalance[msg.sender];
        userBalance[msg.sender] = 0;
        msg.sender.transfer(balance);
        locked = false;
    }
} 

// Changes made:
// - Added a 'locked' boolean to prevent reentrancy
// - Changed 'constant' to 'view' for getBalance function
// - Changed 'throw' to 'revert'
// - Used the 'transfer' function instead of 'call.value' to send ethers to the user's address