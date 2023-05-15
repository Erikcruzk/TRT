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
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_token != address(0), "Invalid token address.");
        require(_to != address(0), "Invalid recipient address.");
        IERC20(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() {
        MinDeposit = 1 ether;
    }

    function deposit() payable public {
        require(msg.value > MinDeposit, "Deposit amount must be greater than the minimum deposit.");
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(Holders[_to] > 0, "Recipient has no tokens to withdraw.");
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint256 _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0, "Recipient has no tokens to withdraw.");
        require(_wei <= Holders[_addr], "Withdrawal amount must be less than or equal to the available balance.");
        Holders[_addr] -= _wei;
        (bool success, ) = _addr.call{value: _wei}("");
        require(success, "Withdrawal failed.");
    }
}