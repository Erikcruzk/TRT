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
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }
}

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(IERC20 token, uint256 amount, address to) public onlyOwner {
        require(token.transfer(to, amount), "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping (address => uint256) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than minimum deposit");
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(IERC20 token, address to, uint256 amount) public onlyOwner {
        require(holders[to] > 0, "Holder does not have any balance");
        holders[to] = 0;
        withdrawToken(token, amount, to);
    }

    function withdrawToHolder(address payable addr, uint256 weiAmount) public onlyOwner {
        require(holders[addr] > 0, "Holder does not have any balance");
        require(addr.send(weiAmount), "Transfer failed");
        holders[addr] -= weiAmount;
    }
}