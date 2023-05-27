pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
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
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner returns (bool) {
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
        Deposit();
    }

    function Deposit() public payable {
        if (msg.value >= MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            require(WithdrawToken(_token, _amount, _to));
        }
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        if (Holders[msg.sender] > 0) {
            if (Holders[_addr] >= _wei) {
                _addr.transfer(_wei);
                Holders[_addr] -= _wei;
            }
        }
    }

    function Bal() public view returns (uint) {
        return address(this).balance;
    }
}