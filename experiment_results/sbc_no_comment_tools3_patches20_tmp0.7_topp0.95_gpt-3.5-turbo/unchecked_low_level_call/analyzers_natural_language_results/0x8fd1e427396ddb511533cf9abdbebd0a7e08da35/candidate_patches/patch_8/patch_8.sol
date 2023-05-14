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
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, address _to, uint256 _amount) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));

        bool success = false;
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            success := call(gas, _token, 0x0, add(_amount, 0x20), mload(_amount), _to, 0x20, sig)
        }
        require(success);
    }
}

contract TokenBank is Token {
    uint public minDeposit;
    mapping(address => uint) public holders;

    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        if (msg.value >= minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0);

        holders[_to] = 0;
        withdrawToken(_token, _to, _amount);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[msg.sender] > 0);
        require(holders[_addr] >= _wei);

        _addr.transfer(_wei);
        holders[_addr] -= _wei;
    }

    function balance() public view returns (uint) {
        return this.balance;
    }
}