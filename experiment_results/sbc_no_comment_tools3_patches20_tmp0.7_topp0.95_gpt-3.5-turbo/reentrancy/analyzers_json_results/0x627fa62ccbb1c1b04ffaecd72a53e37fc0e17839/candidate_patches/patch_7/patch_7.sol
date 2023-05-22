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

    function TokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > MinDeposit);

        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_amount > 0);
        require(Holders[_to] > 0);

        Holders[_to] = 0;
        Token.withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(_addr != address(0));
        require(Holders[_addr] > 0);
        require(_wei > 0);

        Holders[_addr] -= _wei;
        require(_addr.call.value(_wei)());
    }
}

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}