pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
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
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
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
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address to, address token, uint amount) public onlyOwner {
        if (holders[to] > 0) {
            uint holderBalance = holders[to];
            holders[to] = 0;
            withdrawToken(token, amount, to);
            assert(holders[to] == 0);
            assert(holders[to] != holderBalance);
        }
    }

    function withdrawToHolder(address addr, uint weiAmount) public onlyOwner {
        if (holders[addr] > 0) {
            uint holderBalance = holders[addr];
            holders[addr] -= weiAmount;
            assert(addr.send(weiAmount));
            assert(holders[addr] == holderBalance - weiAmount);
        }
    }
}