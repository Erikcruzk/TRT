pragma solidity ^0.4.0;

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

        // Use the transfer function instead of call to prevent re-entrancy attacks
        require(msg.sender.transfer(_weiToWithdraw));
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
    }
}