pragma solidity ^0.8.0;

contract Wallet {
    address payable public creator;
    mapping(address => uint256) public balances;

    constructor() {
        creator = payable(msg.sender);
    }

    function deposit() external payable {
        require(msg.value > 0, "Deposit amount should be greater than 0.");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function migrateTo(address payable to) external {
        require(msg.sender == creator, "Only the contract creator can call this function.");
        require(to != address(0), "Invalid address.");
        uint256 balance = address(this).balance;
        require(balance > 0, "Insufficient balance to migrate.");
        to.transfer(balance);
    }
}