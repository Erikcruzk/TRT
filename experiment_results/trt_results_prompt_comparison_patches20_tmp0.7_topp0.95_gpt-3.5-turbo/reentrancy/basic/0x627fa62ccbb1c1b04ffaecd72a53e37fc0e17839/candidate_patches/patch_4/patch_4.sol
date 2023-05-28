pragma solidity ^0.8.0;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner, "Only the new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        (bool success, ) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
        require(success, "Transfer failed");
    }
}

contract TokenBank is Token {
    uint256 public MinDeposit;
    mapping(address => uint256) public Holders;

    constructor() {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > MinDeposit, "Deposit amount must be greater than MinDeposit");
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(Holders[_to] > 0, "Holder does not have any balance");
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address payable _addr,
        uint256 _wei
    ) public onlyOwner {
        require(Holders[_addr] > 0, "Holder does not have any balance");
        require(_addr.send(_wei), "Transfer failed");
        Holders[_addr] -= _wei;
    }
}