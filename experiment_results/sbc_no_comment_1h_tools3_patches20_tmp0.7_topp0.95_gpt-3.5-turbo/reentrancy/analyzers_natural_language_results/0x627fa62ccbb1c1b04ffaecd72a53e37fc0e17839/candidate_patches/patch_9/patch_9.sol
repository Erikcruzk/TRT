pragma solidity ^0.4.19;

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
        if (msg.sender == newOwner) {
            owner = newOwner;
            newOwner = address(0);
        }
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
    ) public onlyOwner {
        require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount));
    }
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public onlyOwner {
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
    ) public onlyOwner {
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        Token(_token).WithdrawToken(_token, _amount, _to);
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0);
        Holders[_addr] -= _wei;
        require(_addr.call.value(_wei)());
    }
}