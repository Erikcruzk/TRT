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
        require(msg.sender == owner, "Only owner can perform this operation");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        (bool success,) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success, "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping (address => uint) public holders;

    constructor() {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount should be greater than minimum deposit");
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0, "Holder should have a non-zero balance");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint _wei) public onlyOwner {
        require(holders[_addr] >= _wei, "Holder should have sufficient balance");
        holders[_addr] -= _wei;
        (bool success,) = _addr.call{value: _wei}("");
        require(success, "Ether transfer failed");
    }
}