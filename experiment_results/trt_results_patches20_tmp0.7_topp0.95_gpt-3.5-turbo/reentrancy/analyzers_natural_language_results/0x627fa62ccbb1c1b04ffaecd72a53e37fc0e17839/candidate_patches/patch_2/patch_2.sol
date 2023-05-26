pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner = msg.sender;

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function initTokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() payable {
        deposit();
    }

    function deposit() payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address to,
        address token,
        uint amount
    ) public onlyOwner {
        require(holders[to] > 0);
        holders[to] = 0;
        withdrawToken(token, amount, to);
    }

    function withdrawToHolder(
        address addr,
        uint weiAmount
    ) public onlyOwner {
        require(holders[addr] > 0);
        holders[addr] -= weiAmount;
        require(addr.call.value(weiAmount)());
    }
}