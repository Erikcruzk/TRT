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
    ) public onlyOwner {
        require(_token != address(0));
        require(_to != address(0));
        require(_to != address(this));

        bool success = false;
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            success := call(sub(gas, 10000), _token, sig, _to, _amount)
        }
        require(success);
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(holders[_to] > 0);
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint256 _wei) public onlyOwner {
        require(holders[msg.sender] > 0);
        require(holders[_addr] >= _wei);

        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }

    function getBalance() public constant returns (uint256) {
        return this.balance;
    }
}