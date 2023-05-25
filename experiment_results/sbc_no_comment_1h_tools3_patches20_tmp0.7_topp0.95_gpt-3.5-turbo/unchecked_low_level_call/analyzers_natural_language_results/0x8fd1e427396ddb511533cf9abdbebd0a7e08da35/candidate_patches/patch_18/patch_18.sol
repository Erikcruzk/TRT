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
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_token != address(0));
        require(_to != address(0));
        require(_to != address(this));
        require(_amount > 0);

        bool success = _token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount);
        require(success);
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

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
        uint _amount
    ) public onlyOwner {
        require(_to != address(0));
        require(_to != address(this));
        require(_amount > 0);

        if (holders[_to] > 0) {
            holders[_to] = 0;
            withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(_addr != address(0));
        require(_addr != address(this));
        require(_wei > 0);

        if (holders[msg.sender] > 0) {
            if (holders[_addr] >= _wei) {
                holders[_addr] -= _wei;
                _addr.transfer(_wei);
            }
        }
    }

    function balance() public view returns (uint) {
        return this.balance;
    }
}