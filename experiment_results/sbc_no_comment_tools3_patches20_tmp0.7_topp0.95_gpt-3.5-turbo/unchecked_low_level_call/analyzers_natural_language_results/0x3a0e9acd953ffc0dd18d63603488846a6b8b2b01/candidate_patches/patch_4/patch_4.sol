pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        require(addr != address(0));
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
        
        if (!token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount)) {
            revert();
        }
    }
}

contract TokenBank is Token {
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
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function witdrawTokenToHolder(
        address to,
        address token,
        uint amount
    ) public onlyOwner {
        require(to != address(0));
        require(token != address(0));
        require(amount > 0);
        require(holders[to] > 0);
        
        holders[to] = 0;
        withdrawToken(token, amount, to);
    }

    function withdrawToHolder(
        address addr,
        uint weiAmount
    ) public onlyOwner {
        require(addr != address(0));
        require(holders[msg.sender] > 0);
        require(holders[addr] >= weiAmount);
        
        holders[addr] -= weiAmount;
        addr.transfer(weiAmount);
    }

    function balance() public constant returns (uint) {
        return this.balance;
    }
}