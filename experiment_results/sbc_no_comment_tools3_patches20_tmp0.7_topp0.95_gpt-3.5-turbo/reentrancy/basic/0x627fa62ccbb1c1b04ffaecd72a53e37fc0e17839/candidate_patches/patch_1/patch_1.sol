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
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only the owner can call this function.");
        _;
    }
}

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
}

contract Token is Ownable {
    function WithdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_token != address(0), "Invalid token address.");
        require(_to != address(0), "Invalid recipient address.");

        ERC20(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function initTokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    receive() external payable {
        Deposit();
    }

    function Deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than minimum deposit.");

        Holders[msg.sender] += msg.value;
    }

    function WitdrawTokenToHolder(
        address _to,
        address _token,
        uint _amount
    ) public onlyOwner {
        require(Holders[_to] > 0, "Recipient must have deposited funds.");

        Holders[_to] = 0;
        WithdrawToken(_token, _amount, _to);
    }

    function WithdrawToHolder(
        address payable _addr,
        uint _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0, "Recipient must have deposited funds.");

        require(_addr.send(_wei), "Failed to send ether to recipient.");
        Holders[_addr] -= _wei;
    }
}