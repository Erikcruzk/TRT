pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0)); // Prevents owner from transferring ownership to 0x0 address.
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner); // Require new owner to confirm ownership.
        owner = newOwner;
        delete newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner); // Replaced if statement with require statement.
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0)); // Prevents owner from transferring tokens to 0x0 address.
        require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount)); // Checks if token transfer was successful.
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit); // Requires deposit to be greater than minDeposit.
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0); // Requires _to address to have a balance.
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner payable {
        require(holders[_addr] > 0); // Requires _addr address to have a balance.
        require(_addr != address(0)); // Prevents owner from transferring ether to 0x0 address.
        require(_addr.call.value(_wei)()); // Checks if ether transfer was successful.
        holders[_addr] -= _wei;
    }
}