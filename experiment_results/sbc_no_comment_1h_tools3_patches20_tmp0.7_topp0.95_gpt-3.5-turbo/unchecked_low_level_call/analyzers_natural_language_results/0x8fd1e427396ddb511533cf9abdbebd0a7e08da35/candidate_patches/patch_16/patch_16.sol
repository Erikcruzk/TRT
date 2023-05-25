pragma solidity ^0.4.18;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        delete newOwner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(_to != address(this));
        require(_to != owner);

        bool success = false;
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            success := call(gas, _token, 0x0, add(_amount, 0x20), mload(_amount), _to, 0x20, sig, 0x20)
        }
        require(success);
    }
}

contract TokenBank is Token {
    uint public MinDeposit;
    mapping(address => uint) public Holders;

    function TokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }

    function() public payable {
        Deposit();
    }

    function Deposit() public payable {
        require(msg.value >= MinDeposit);
        Holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(address _to, address _token, uint256 _amount) public onlyOwner {
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(Holders[_addr] >= _wei);
        require(_addr != address(0));
        require(_addr != address(this));
        require(_addr != owner);
        Holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}