pragma solidity ^0.4.19;

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
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));

        bool success = false;
        bytes4 signature = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, signature)
            mstore(add(ptr, 0x04), _to)
            mstore(add(ptr, 0x24), _amount)
            success := call(sub(gas, 10000), _token, 0, ptr, 0x44, 0, 0)
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
        deposit();
    }

    function deposit() public payable {
        if (msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(_to != address(0));
        require(_token != address(0));
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(_addr != address(0));
        require(Holders[_addr] >= _wei);
        Holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}