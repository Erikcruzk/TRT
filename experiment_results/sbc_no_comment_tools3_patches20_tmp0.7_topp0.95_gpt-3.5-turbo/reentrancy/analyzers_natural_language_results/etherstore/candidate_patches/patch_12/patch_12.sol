pragma solidity ^0.4.0;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    mapping(address => bool) public frozenAccount;

    function depositFunds() public payable {
        require(!frozenAccount[msg.sender]);
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!frozenAccount[msg.sender]);
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        frozenAccount[msg.sender] = true; // freeze account during the function call
        if (msg.sender.call.value(_weiToWithdraw)()) {
            balances[msg.sender] -= _weiToWithdraw;
            lastWithdrawTime[msg.sender] = now;
        }
        frozenAccount[msg.sender] = false; // unfreeze account after the function call
    }
}