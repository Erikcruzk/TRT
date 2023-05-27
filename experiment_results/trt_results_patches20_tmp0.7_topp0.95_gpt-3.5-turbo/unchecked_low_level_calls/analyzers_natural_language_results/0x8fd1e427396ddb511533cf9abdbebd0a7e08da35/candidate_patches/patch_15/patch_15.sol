pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
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
    function withdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        require(token != address(0));
        require(to != address(0));
        require(amount > 0);

        bool success = token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount);
        require(success);
    }
}

contract TokenBank is Token {
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
        if (msg.value >= MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(Holders[_to] > 0);
        require(_amount > 0);

        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(_addr != address(0));
        require(Holders[msg.sender] > 0);
        require(Holders[_addr] >= _wei);
        require(_wei > 0);

        Holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }

    function bal() public constant returns (uint) {
        return this.balance;
    }
}