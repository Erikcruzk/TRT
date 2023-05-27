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
        newOwner = 0x0;
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
    uint public MinDeposit;
    mapping (address => uint) public Holders;

    function TokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function () public payable {
        deposit();
    }

    function deposit() public payable {
        if(msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if(Holders[_to] > 0) {
            Holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner payable {
        if(Holders[_addr] > 0) {
            require(_addr.call.value(_wei)());
            Holders[_addr] -= _wei;
        }
    }
}