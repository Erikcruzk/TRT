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
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        (bool success, bytes memory data) = token.call(abi.encodeWithSignature("transfer(address,uint256)", to, amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function deposit() payable public {
        require(msg.value > MinDeposit, "Minimum deposit not met");
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(Holders[_to] > 0, "Holder has no balance");
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address payable _addr, uint _wei) public onlyOwner {
        require(Holders[_addr] > 0, "Holder has no balance");
        Holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}