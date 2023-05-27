pragma solidity ^0.4.24;

contract Proxy {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0));
        require(msg.value > 0);
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success);
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
        require(msg.value > 0.5 ether);
        deposits[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0);
        require(deposits[msg.sender] >= amount);
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}