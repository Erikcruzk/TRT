pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        msg.sender.transfer(_weiToWithdraw);
    }
} 

//Changes made:
//1. Updated the solidity compiler version to ^0.4.24 as it is the latest stable version.
//2. Removed the external call in the withdrawFunds function and used the transfer() function instead. 
//This prevents re-entrancy attacks as the transfer() function only forwards a fixed amount of gas to the receiver. 
//3. Made minor formatting changes to improve readability.