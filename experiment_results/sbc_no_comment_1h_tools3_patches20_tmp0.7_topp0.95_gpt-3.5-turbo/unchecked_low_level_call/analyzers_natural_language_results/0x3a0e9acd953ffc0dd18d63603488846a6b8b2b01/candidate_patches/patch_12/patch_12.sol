pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function transfer(address _to, uint256 _amount) public onlyOwner returns (bool) {
        require(_to != address(0));
        require(_amount > 0);
        return true;
    }

    function WithdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner returns (bool) {
        require(transfer(to, amount));
        return true;
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public onlyOwner {
        MinDeposit = 1 ether;
    }

    function() public payable {
        Deposit();
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner returns (bool) {
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        require(WithdrawToken(_token, _amount, _to));
        return true;
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public payable onlyOwner {
        require(Holders[msg.sender] > 0);
        require(Holders[_addr] >= _wei);
        _addr.transfer(_wei);
        Holders[_addr] -= _wei;
    }

    function Bal() public constant returns (uint) {
        return this.balance;
    }
}