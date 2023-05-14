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
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}

interface Token {
    function transfer(address _to, uint256 _value) external returns (bool);
}

contract TokenBank is Ownable {
    uint256 public MinDeposit;
    mapping(address => uint256) public Holders;

    constructor() {
        MinDeposit = 1 ether;
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount is less than minimum deposit");
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(Holders[_to] > 0, "Holder does not have any balance");
        Holders[_to] = 0;
        Token(_token).transfer(_to, _amount);
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        require(Holders[_addr] > 0, "Holder does not have any balance");
        Holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}