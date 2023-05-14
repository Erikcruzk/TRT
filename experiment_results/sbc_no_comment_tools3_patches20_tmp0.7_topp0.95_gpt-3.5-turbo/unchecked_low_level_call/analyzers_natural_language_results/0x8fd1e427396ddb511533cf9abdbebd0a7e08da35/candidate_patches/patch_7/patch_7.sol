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
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner returns (bool) {
        require(_token != address(0));
        require(_to != address(0));

        return ERC20(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function TokenBank() public {
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value >= minDeposit);

        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner returns (bool) {
        require(holders[_to] > 0);

        holders[_to] = 0;
        return Token.withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(holders[msg.sender] > 0);
        require(holders[_addr] >= _wei);

        _addr.transfer(_wei);
        holders[_addr] -= _wei;
    }

    function bal() public view returns (uint) {
        return this.balance;
    }
}

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}