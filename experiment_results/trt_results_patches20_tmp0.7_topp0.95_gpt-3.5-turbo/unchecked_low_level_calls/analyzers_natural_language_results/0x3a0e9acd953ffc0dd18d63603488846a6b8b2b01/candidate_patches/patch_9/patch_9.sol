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
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner returns (bool) {
        require(_token != address(0));
        require(_to != address(0));
        require(_amount > 0);

        return ERC20(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function TokenBank() public {
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
    ) public onlyOwner returns (bool) {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            return Token.withdrawToken(_token, _amount, _to);
        }
        return false;
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (Holders[_addr] >= _wei) {
            Holders[_addr] -= _wei;
            _addr.transfer(_wei);
        }
    }

    function balance() public view returns (uint) {
        return this.balance;
    }
}

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}