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
        require(msg.sender == newOwner, "Only the new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}

interface Token {
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    receive() external payable {
        Deposit();
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WithdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(Holders[_to] > 0, "Holder does not exist");
        Holders[_to] = 0;
        Token(_token).transfer(_to, _amount);
    }

    function WithdrawToHolder(
        address payable _addr,
        uint _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0, "Holder does not exist");
        if (_addr.send(_wei)) {
            Holders[_addr] -= _wei;
        }
    }
}