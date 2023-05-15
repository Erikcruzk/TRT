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
        require(_token != address(0));
        require(_to != address(0));
        require(_amount > 0);

        bool success = false;

        // use call to transfer tokens
        // address.call(bytes4(keccak256("functionName(argType1,argType2)")) ,arg1, arg2)
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            success := call(sub(gas, 10000), _token, sig, _to, _amount)
        }

        require(success);
    }
}

contract TokenBank is Ownable {
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
        if (Holders[_to] > 0) {
            Holders[_to] = 0;
            Token token = Token(_token);
            token.withdrawToken(_token, _amount, _to);
        }
    }

    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        if (Holders[_addr] > 0 && _wei <= this.balance) {
            Holders[_addr] = 0;
            _addr.transfer(_wei);
        }
    }
}