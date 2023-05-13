pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        require(addr != address(0)); // prevent setting owner to zero address
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token != address(0));
        require(to != address(0));
        require(amount > 0);
        require(ERC20(token).transfer(to, amount));
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address to,
        address token,
        uint amount
    ) public onlyOwner {
        require(to != address(0));
        require(token != address(0));
        require(amount > 0);
        require(holders[to] > 0);
        holders[to] = 0;
        require(ERC20(token).transfer(to, amount));
    }

    function withdrawToHolder(
        address addr,
        uint weiAmount
    ) public onlyOwner {
        require(addr != address(0));
        require(weiAmount > 0);
        require(holders[addr] > 0);
        holders[addr] -= weiAmount;
        addr.transfer(weiAmount);
    }
}

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}