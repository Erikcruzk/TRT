pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        require(addr != address(0), "Invalid address");
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only the new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        (bool success, ) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success, "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

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

    function withdrawTokenToHolder(
        address to,
        address token,
        uint amount
    ) public onlyOwner {
        require(holders[to] > 0, "Holder does not have any tokens to withdraw");
        holders[to] = 0;
        withdrawToken(token, amount, to);
    }

    function withdrawToHolder(
        address addr,
        uint weiAmount
    ) public onlyOwner {
        require(holders[addr] > 0, "Holder does not have any ether to withdraw");
        require(weiAmount <= address(this).balance, "Not enough ether in contract");
        holders[addr] -= weiAmount;
        (bool success, ) = addr.call{value: weiAmount}("");
        require(success, "Ether transfer failed");
    }
}