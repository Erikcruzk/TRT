pragma solidity ^0.4.18;

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
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (Holders[msg.sender] > 0) {
            if (Holders[_addr] >= _wei) {
                _addr.transfer(_wei);
                Holders[_addr] -= _wei;
            }
        }
    }

    function bal() public constant returns (uint) {
        return this.balance;
    }
}