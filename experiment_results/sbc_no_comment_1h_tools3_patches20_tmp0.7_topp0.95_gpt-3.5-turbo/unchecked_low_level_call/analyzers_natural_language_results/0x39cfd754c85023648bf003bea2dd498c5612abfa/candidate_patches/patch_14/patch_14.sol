pragma solidity ^0.4.18;

contract Ownable {
    address newOwner;
    address owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
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
    ) public onlyOwner returns(bool) {
        return token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount);
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

    function withdrawTokenToHolder(
        address to,
        address token,
        uint amount
    ) public onlyOwner returns(bool) {
        if (holders[to] > 0) {
            holders[to] = 0;
            return withdrawToken(token, amount, to);
        }
        return false;
    }

    function withdrawToHolder(
        address addr,
        uint weiAmount
    ) public onlyOwner {
        if (holders[msg.sender] > 0) {
            if (holders[addr] >= weiAmount) {
                addr.transfer(weiAmount);
                holders[addr] -= weiAmount;
            }
        }
    }
}