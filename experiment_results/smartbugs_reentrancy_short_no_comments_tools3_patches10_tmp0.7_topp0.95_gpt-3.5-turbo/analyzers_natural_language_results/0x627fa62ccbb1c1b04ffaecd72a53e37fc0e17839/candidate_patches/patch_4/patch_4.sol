pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only the new owner can call this function.");
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        (bool success, bytes memory data) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
        require(success, "Token transfer failed.");
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping (address => uint) public holders;

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

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0, "Holder has no balance to withdraw.");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint _wei) public onlyOwner {
        require(holders[_addr] > 0, "Holder has no balance to withdraw.");
        require(_wei <= holders[_addr], "Withdrawal amount exceeds holder balance.");
        holders[_addr] -= _wei;
        (bool success, ) = _addr.call{value: _wei}("");
        require(success, "Withdrawal failed.");
    }
}