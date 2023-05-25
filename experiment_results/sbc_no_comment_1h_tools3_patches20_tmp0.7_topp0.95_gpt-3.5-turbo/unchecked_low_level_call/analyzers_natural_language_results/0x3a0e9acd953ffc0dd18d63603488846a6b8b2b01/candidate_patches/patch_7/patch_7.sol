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
    ) public onlyOwner returns (bool success) {
        return _token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount);
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
    ) public onlyOwner returns (bool success) {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            return withdrawToken(_token, _amount, _to);
        }
        return false;
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner returns (bool success) {
        if (Holders[msg.sender] > 0) {
            if (Holders[_addr] >= _wei) {
                Holders[_addr] -= _wei;
                _addr.transfer(_wei);
                return true;
            }
        }
        return false;
    }

    function balance() public view returns (uint) {
        return this.balance;
    }
}