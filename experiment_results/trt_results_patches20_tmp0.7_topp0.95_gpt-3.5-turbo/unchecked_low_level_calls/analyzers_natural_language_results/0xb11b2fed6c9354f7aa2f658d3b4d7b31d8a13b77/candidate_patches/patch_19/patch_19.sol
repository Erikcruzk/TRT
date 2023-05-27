pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    function transferOwner(address _owner) public onlyOwner {
        require(_owner != address(0), "Invalid new owner address.");
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address.");
        require(msg.value > 0, "No ether sent with the transaction.");
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success, "External function call failed.");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function vault() public payable {
        if (msg.sender == tx.origin) {
            owner = msg.sender;
            deposit();
        }
    }

    function deposit() public payable {
        require(msg.value > 0, "No ether sent with the transaction.");
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than zero.");
        require(deposits[msg.sender] >= amount, "Insufficient balance.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}