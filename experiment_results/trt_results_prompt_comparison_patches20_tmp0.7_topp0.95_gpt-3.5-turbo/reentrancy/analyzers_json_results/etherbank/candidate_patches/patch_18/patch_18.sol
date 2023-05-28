pragma solidity ^0.4.26;

contract EtherBank {
    mapping(address => uint) userBalances;

    function getBalance(address user) public view returns (uint) {
        return userBalances[user];
    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        uint amountToWithdraw = userBalances[msg.sender];
        userBalances[msg.sender] = 0;
        
        if(msg.sender.send(amountToWithdraw)){
            //successful transfer
        }else{
            userBalances[msg.sender] = amountToWithdraw;
            //revert the changes
        }
    }
}