pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0)); // prevent setting owner to address 0
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0); // reset newOwner
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
        require(_to != address(0)); // prevent sending tokens to address 0
        require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount));
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    constructor() public {
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
    ) public onlyOwner {
        require(Holders[_to] > 0); // prevent withdrawing to an empty account
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint _wei
    ) public onlyOwner {
        require(Holders[_addr] >= _wei); // prevent withdrawing more than the account balance
        _addr.transfer(_wei);
        Holders[_addr] -= _wei;
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}