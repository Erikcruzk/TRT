pragma solidity ^0.4.19;

contract Ownable {
    address public owner;
    address public newOwner;

    function Ownable() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function confirmOwnership() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        delete newOwner;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));

        ERC20 token = ERC20(_token);
        token.transfer(_to, _amount);
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function () public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0);
        require(_to != address(0));
        require(_token != address(0));

        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[_addr] > 0);
        require(_addr != address(0));
        require(_wei <= holders[_addr]);

        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}