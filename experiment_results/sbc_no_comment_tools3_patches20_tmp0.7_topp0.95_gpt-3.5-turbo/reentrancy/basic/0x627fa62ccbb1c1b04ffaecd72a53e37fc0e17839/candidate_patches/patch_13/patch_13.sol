pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "You are not the new owner");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
}

contract Token is Ownable {
    function WithdrawToken(
        address token,
        uint256 amount,
        address to
    ) public onlyOwner {
        (bool success, ) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success, "Transfer failed");
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() payable external {
        Deposit();
    }

    function Deposit() payable public {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function WitdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(Holders[_to] > 0, "Holder has no balance");
        Holders[_to] = 0;
        WithdrawToken(_token, _amount, _to);
    }

    function WithdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0, "Holder has no balance");
        Holders[_addr] -= _wei;
        (bool success, ) = _addr.call{value: _wei}("");
        require(success, "Transfer failed");
    }
}