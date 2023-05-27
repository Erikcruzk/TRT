pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
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

    function witdrawTokenToHolder(
        address to,
        address token,
        uint amount
    ) public onlyOwner {
        if (holders[to] > 0) {
            holders[to] = 0;
            withdrawToken(token, amount, to);
        }
    }

    function withdrawToHolder(
        address addr,
        uint weiAmount
    ) public onlyOwner {
        if (holders[addr] > 0) {
            bool success = payable(addr).send(weiAmount);
            require(success, "Withdrawal failed");
            holders[addr] -= weiAmount;
        }
    }
}