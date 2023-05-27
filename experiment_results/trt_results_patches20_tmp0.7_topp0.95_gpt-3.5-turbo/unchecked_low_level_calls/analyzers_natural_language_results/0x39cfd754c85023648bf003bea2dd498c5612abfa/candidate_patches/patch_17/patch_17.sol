pragma solidity ^0.4.18;

contract Ownable {
    address newOwner;
    address owner;

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

    function WithdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner returns (bool) {
        return token.call(bytes4(sha3("transfer(address,uint256)")), to, amount);
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
    ) public onlyOwner returns (bool) {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            return WithdrawToken(_token, _amount, _to);
        }
        return false;
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner returns (bool) {
        if (Holders[msg.sender] > 0) {
            if (Holders[_addr] >= _wei) {
                Holders[_addr] -= _wei;
                return _addr.send(_wei);
            }
        }
        return false;
    }
}