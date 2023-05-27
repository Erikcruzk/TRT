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
        require(msg.sender == newOwner, "Only new owner can confirm ownership");
        owner = newOwner;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this function");
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        (bool success, bytes memory data) = _token.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _amount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Token transfer failed");
    }
}

contract TokenBank is Token {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    constructor() {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(holders[_to] > 0, "Holder does not exist");
        holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address payable _addr,
        uint256 _wei
    ) public onlyOwner {
        require(holders[_addr] > 0, "Holder does not exist");
        require(_addr.send(_wei), "Ether transfer failed");
        holders[_addr] -= _wei;
    }
}