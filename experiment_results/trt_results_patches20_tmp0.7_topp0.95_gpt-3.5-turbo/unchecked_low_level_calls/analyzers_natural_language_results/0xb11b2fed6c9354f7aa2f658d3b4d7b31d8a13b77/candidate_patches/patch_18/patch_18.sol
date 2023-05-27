pragma solidity ^0.4.24;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
    address private owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid new owner address.");
        owner = newOwner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Invalid target address.");
        require(msg.value > 0, "No ether sent with the function call.");
        bool success;
        bytes memory result;
        (success, result) = target.call.value(msg.value)(data);
        require(success, "External function call failed.");
    }
}

contract DepositProxy is Proxy {
    mapping(address => uint256) public deposits;

    constructor() public payable {}

    function vault() public payable {
        require(msg.sender == tx.origin, "Function can only be called by an externally-owned account.");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "No ether sent with the function call.");
        if (msg.value > 0.5 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than 0.");
        require(deposits[msg.sender] >= amount, "Insufficient funds for withdrawal.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}