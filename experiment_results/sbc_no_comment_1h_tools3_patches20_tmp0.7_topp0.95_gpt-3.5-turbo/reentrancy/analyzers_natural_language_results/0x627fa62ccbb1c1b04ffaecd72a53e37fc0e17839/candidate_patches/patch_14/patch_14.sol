pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        delete newOwner;
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
        require(Token(_token).transfer(_to, _amount));
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
        Deposit();
    }

    function Deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        WithdrawToken(_token, _amount, _to);
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(_addr != address(0));
        require(_wei > 0);
        require(Holders[_addr] >= _wei);
        Holders[_addr] -= _wei;
        require(_addr.call.value(_wei)());
    }
}