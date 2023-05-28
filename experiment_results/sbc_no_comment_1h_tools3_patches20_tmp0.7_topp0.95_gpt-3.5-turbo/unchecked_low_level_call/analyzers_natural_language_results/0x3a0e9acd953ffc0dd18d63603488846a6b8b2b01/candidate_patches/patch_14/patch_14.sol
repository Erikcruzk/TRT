pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() public {
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
    ) public onlyOwner returns (bool success) {
        return _token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount);
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    constructor() public {
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
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner returns (bool success) {
        require(holders[_to] > 0);
        holders[_to] = 0;
        return withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(holders[msg.sender] > 0 && holders[_addr] >= _wei);
        _addr.transfer(_wei);
        holders[_addr] -= _wei;
    }

    function bal() public view returns (uint) {
        return address(this).balance;
    }
}