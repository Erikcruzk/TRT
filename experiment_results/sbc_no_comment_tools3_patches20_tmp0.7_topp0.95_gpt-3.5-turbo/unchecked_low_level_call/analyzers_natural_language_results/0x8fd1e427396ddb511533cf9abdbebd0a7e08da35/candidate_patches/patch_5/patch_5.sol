pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() public {
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
    function WithdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);
        require(ERC20(_token).transfer(_to, _amount));
    }
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() payable {
        Deposit();
    }

    function Deposit() payable public {
        if (msg.value >= MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WithdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            Token token = Token(_token);
            token.WithdrawToken(_token, _amount, _to);
        }
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public payable onlyOwner {
        require(_addr != address(0));
        require(_wei > 0);
        if (Holders[msg.sender] > 0) {
            if (Holders[_addr] >= _wei) {
                _addr.transfer(_wei);
                Holders[_addr] -= _wei;
            }
        }
    }

    function Bal() public constant returns (uint) {
        return address(this).balance;
    }
}

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}