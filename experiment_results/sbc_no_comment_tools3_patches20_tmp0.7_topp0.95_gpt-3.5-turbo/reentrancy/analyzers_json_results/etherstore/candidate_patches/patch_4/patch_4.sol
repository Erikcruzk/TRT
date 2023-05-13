pragma solidity ^0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    bool private stopped = false;
    address private owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier stopInEmergency {
        require(!stopped);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function depositFunds() public payable {
        require(!stopped);
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public onlyOwner stopInEmergency {
        require(balances[msg.sender] >= _weiToWithdraw);
        require(_weiToWithdraw <= withdrawalLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        msg.sender.transfer(_weiToWithdraw);
    }

    function emergencyStop() public onlyOwner {
        stopped = true;
    }

    function release() public onlyOwner {
        stopped = false;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}