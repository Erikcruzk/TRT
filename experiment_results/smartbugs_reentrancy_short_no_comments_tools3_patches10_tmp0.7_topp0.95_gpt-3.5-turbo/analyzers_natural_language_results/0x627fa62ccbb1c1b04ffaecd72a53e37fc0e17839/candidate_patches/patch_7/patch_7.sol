pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address.");
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner, "Only the new owner can accept ownership.");
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        (bool success, ) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
        require(success, "Token transfer failed.");
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    constructor() {
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount must be greater than the minimum deposit.");
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(holders[_to] > 0, "The holder has no balance.");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint256 _wei) public onlyOwner {
        require(holders[_addr] > 0, "The holder has no balance.");
        holders[_addr] -= _wei;
        (bool success, ) = _addr.call{value: _wei}("");
        require(success, "Withdrawal failed.");
    }
}