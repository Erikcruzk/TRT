pragma solidity ^0.4.0;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    event FundsDeposited(address indexed depositor, uint256 value);
    event FundsWithdrawn(address indexed withdrawer, uint256 value);

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);

        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;

        emit FundsWithdrawn(msg.sender, _weiToWithdraw);

        assert(msg.sender.call.value(_weiToWithdraw)());
    }
}