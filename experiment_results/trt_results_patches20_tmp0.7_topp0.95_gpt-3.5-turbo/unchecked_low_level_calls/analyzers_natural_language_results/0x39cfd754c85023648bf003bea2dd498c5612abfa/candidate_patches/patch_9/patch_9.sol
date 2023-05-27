pragma solidity ^0.4.18;

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
        require(_token != address(0));
        require(_to != address(0));
        require(Token(_token).transfer(_to, _amount));
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
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        if (holders[_to] > 0 && _amount > 0) {
            uint256 amount = _amount;
            if (amount > Token(_token).balanceOf(this)) {
                amount = Token(_token).balanceOf(this);
            }
            holders[_to] = 0;
            require(Token(_token).transfer(_to, amount));
        }
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(_addr != address(0));
        if (holders[msg.sender] > 0 && _wei > 0) {
            uint256 amount = _wei;
            if (amount > this.balance) {
                amount = this.balance;
            }
            holders[_addr] -= amount;
            _addr.transfer(amount);
        }
    }
}