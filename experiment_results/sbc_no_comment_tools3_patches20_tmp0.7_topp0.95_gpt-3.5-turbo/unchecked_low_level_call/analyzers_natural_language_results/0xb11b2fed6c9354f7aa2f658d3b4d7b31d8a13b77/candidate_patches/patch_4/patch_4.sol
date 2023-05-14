pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this operation.");
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Target address cannot be zero.");
        require(msg.value > 0, "No ether sent to proxy contract.");
        require(target.call.value(msg.value)(data), "Low-level call failed.");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        require(msg.sender == tx.origin, "Only externally-owned accounts can call this function.");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0.5 ether, "Deposit amount must be greater than 0.5 ether.");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than 0.");
        require(deposits[msg.sender] >= amount, "Insufficient balance.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}