pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address");
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only new owner can confirm");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
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
        require(_to != address(0), "Invalid address");
        require(_token != address(0), "Invalid token address");
        IERC20(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount must be greater than minimum deposit");
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(holders[_to] > 0, "Holder has no balance");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address payable _addr,
        uint _wei
    ) public onlyOwner {
        require(holders[_addr] > 0, "Holder has no balance");
        require(_wei <= address(this).balance, "Insufficient balance");
        holders[_addr] -= _wei;
        (bool success, ) = _addr.call{value: _wei}("");
        require(success, "Transfer failed");
    }
}