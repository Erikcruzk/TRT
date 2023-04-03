/*
 * @source: etherscan.io 
 * @author:
 * @vulnerable_at_lines: 94
 */

pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }
    
    function confirmOwner() public {
        require(msg.sender == newOwner, "Not authorized");
        owner = newOwner;
        newOwner = address(0);
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Not authorized");
        _;
    }
}

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        ERC20(token).transfer(to, amount); 
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping (address => uint) public holders;
    
    constructor() {
        minDeposit = 1 ether;
    }
    
    receive() external payable {
        deposit();
    }
   
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount is less than minimum required");
        holders[msg.sender] += msg.value;
    }
    
    function withdrawTokenToHolder(address to, address token, uint amount) public onlyOwner {
        require(holders[to] > 0, "Holder has no balance");
        holders[to] = 0;
        withdrawToken(token, amount, to);     
    }
   
    function withdrawToHolder(address payable addr, uint weiAmount) public onlyOwner {
        require(holders[addr] > 0, "Holder has no balance");
        require(address(this).balance >= weiAmount, "Insufficient balance in contract");
        holders[addr] -= weiAmount;
        addr.transfer(weiAmount);
    }
}