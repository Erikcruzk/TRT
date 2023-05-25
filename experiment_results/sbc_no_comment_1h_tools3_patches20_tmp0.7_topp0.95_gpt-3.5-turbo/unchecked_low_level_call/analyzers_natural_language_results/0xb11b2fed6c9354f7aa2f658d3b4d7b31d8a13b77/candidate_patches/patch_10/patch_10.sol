pragma solidity ^0.4.24;

contract Proxy {
    address public Owner;

    modifier onlyOwner() {
        require(msg.sender == Owner, "Only the owner can call this function.");
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
        require(target.call.value(msg.value)(data), "Low level call failed.");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public Deposits;

    function() public payable {}

    function Vault() public payable {
        if (msg.sender == tx.origin) {
            Owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        if (msg.value > 0.5 ether) {
            Deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than 0.");
        require(Deposits[msg.sender] >= amount, "Insufficient balance.");
        Deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}