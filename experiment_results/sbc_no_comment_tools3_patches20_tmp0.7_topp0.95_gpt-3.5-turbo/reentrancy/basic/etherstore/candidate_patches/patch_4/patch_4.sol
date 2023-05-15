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

        // Update the balance before sending the funds
        balances[msg.sender] -= _weiToWithdraw;

        // Use the transfer function instead of call.value to prevent re-entrancy attacks
        msg.sender.transfer(_weiToWithdraw);

        // Update the last withdrawal time
        lastWithdrawTime[msg.sender] = now;
    }
}