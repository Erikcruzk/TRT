pragma solidity ^0.4.23;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target.call.value(msg.value)(data));
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > 0.25 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0 && deposits[msg.sender] >= amount);
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
} 

//Changes Made:
//1. Added a constructor in Proxy contract to initialize owner variable.
//2. Changed if statement in proxy function to require statement to check the return value of external call.
//3. Removed Vault function in VaultProxy contract as it is unnecessary.
//4. Added require statements in withdraw function to check if the amount is greater than 0 and the depositor has enough balance. Also, deducted the withdrawn amount from depositor's balance before transferring it to owner.