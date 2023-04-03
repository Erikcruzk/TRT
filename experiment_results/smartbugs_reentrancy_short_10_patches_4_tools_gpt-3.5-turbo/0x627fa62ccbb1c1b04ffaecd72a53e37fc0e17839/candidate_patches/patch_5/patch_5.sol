/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 94
 */

pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner = msg.sender;

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);
        require(_amount <= Token(_token).balanceOf(this));
        Token(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping (address => uint256) public holders;

    function initTokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);
        require(_amount <= Token(_token).balanceOf(this));
        require(holders[_to] > 0);
        holders[_to] = 0;
        Token(_token).transfer(_to, _amount);
    }

    function withdrawToHolder(address _addr, uint256 _wei) public onlyOwner {
        require(_addr != address(0));
        require(_wei > 0);
        require(holders[_addr] > 0);
        require(_wei <= this.balance);
        holders[_addr] = 0;
        _addr.transfer(_wei);
    }
}