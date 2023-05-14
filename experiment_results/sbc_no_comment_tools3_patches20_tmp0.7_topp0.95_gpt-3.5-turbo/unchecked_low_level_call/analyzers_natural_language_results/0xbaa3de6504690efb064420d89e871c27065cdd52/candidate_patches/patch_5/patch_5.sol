pragma solidity ^0.4.23;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        require(_owner != address(0), "New owner address cannot be zero.");
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Target address cannot be zero.");
        require(msg.value > 0, "Value must be greater than zero.");
        require(target.call.value(msg.value)(data), "Low-level call failed.");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function Vault() public payable {
        require(msg.sender == tx.origin, "Vault can only be called by an external account.");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.25 ether, "Deposit must be greater than 0.25 ether.");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than zero.");
        require(amount <= deposits[msg.sender], "Insufficient balance.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}