pragma solidity ^0.8.0;

contract Ownable {
    address private newOwner;
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only the new owner can confirm ownership");
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success, "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint256 public MinDeposit;
    mapping(address => uint256) public Holders;

    constructor() {
        MinDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount should be greater than minimum deposit");
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(Holders[_to] > 0, "The holder should have a positive balance to withdraw tokens");
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        require(Holders[_addr] > 0, "The holder should have a positive balance to withdraw ethers");
        require(_addr.send(_wei), "Ether transfer failed");
        Holders[_addr] -= _wei;
    }
}