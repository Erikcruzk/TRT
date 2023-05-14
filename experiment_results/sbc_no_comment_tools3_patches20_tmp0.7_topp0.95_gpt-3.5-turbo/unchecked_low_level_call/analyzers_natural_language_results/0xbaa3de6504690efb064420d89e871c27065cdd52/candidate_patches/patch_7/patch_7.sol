pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Target address cannot be zero");
        require(msg.value > 0, "Value sent must be greater than zero");
        bool success;
        bytes memory returnedData;
        (success, returnedData) = target.call.value(msg.value)(data);
        require(success, "Low level call failed");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function Vault() public payable {
        require(msg.sender == tx.origin, "Vault can only be created by an externally-owned account");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.25 ether, "Deposit amount must be greater than 0.25 ether");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than zero");
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}