pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only the new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this function");
        _;
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_token != address(0), "Invalid token address");
        require(_to != address(0), "Invalid recipient address");

        bool success = IERC20(_token).transfer(_to, _amount);
        require(success, "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    fallback() payable external {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount is below minimum");

        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(holders[_to] > 0, "Recipient has no balance to withdraw");
        require(_amount > 0, "Withdrawal amount should be greater than zero");

        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address payable _addr,
        uint256 _wei
    ) public onlyOwner {
        require(holders[_addr] > 0, "Recipient has no balance to withdraw");
        require(_wei > 0, "Withdrawal amount should be greater than zero");

        bool success = _addr.send(_wei);
        require(success, "Withdrawal failed");

        holders[_addr] -= _wei;
    }
}