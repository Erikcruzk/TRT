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
        require(msg.sender == newOwner, "Only the new owner can confirm ownership.");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function WithdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        IERC20(token).transfer(to, amount);
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function deposit() payable public {
        require(msg.value > MinDeposit, "Deposit amount is less than the minimum required amount.");
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(Holders[_to] > 0, "Recipient does not have any tokens to withdraw.");
        Holders[_to] = 0;
        WithdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address payable _addr,
        uint _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0, "Recipient does not have any tokens to withdraw.");
        require(_addr.send(_wei), "Failed to send Ether.");
        Holders[_addr] -= _wei;
    }
}