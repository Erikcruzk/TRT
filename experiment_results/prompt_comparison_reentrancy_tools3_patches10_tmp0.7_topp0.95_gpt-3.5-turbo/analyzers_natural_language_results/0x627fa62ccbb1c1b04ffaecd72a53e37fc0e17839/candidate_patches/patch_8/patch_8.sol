pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        require(addr != address(0), "Invalid address");
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Unauthorized");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }
}

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Invalid amount");
        require(to != address(0), "Invalid recipient address");
        ERC20(token).transfer(to, amount);
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Insufficient deposit amount");
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address to,
        address token,
        uint256 amount
    ) public onlyOwner {
        require(to != address(0), "Invalid recipient address");
        require(holders[to] > 0, "Holder has no balance");
        require(amount > 0, "Invalid amount");
        holders[to] = 0;
        withdrawToken(token, amount, to);
    }

    function withdrawToHolder(
        address payable addr,
        uint256 weiAmount
    ) public payable onlyOwner {
        require(addr != address(0), "Invalid recipient address");
        require(holders[addr] > 0, "Holder has no balance");
        require(weiAmount > 0, "Invalid amount");
        holders[addr] -= weiAmount;
        (bool success, ) = addr.call{value: weiAmount}("");
        require(success, "Failed to transfer funds");
    }
}