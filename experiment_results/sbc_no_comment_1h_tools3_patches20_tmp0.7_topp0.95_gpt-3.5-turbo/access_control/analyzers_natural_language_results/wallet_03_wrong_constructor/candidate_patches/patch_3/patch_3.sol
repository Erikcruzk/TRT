pragma solidity ^0.4.24;

contract Wallet {
    address public creator; // made creator public for visibility

    mapping(address => uint256) public balances; // made balances public for visibility

    constructor() public { // constructor instead of initWallet
        creator = msg.sender;
    }

    function deposit() public payable {
        require(balances[msg.sender] + msg.value >= balances[msg.sender]); // changed assert to require
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender]);
        balances[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }

    function migrateTo(address to) public {
        require(creator == msg.sender);
        to.transfer(address(this).balance); // added address() to this
    }
}