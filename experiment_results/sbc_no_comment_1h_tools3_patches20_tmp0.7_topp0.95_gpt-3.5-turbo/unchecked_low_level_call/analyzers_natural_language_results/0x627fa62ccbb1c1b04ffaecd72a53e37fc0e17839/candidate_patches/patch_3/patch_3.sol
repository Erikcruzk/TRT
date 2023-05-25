pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function.");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only new owner can call this function.");
        owner = newOwner;
        newOwner = address(0);
    }
}

interface IToken {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_token != address(0), "Invalid token address");
        require(_to != address(0), "Invalid recipient address");

        bool success;
        bytes memory data;

        (success, data) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
        require(success, "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping (address => uint256) public holders;

    constructor() {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0, "Holder has no balance to withdraw");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        require(holders[_addr] > 0, "Holder has no balance to withdraw");
        require(_wei <= holders[_addr], "Insufficient balance to withdraw");

        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}