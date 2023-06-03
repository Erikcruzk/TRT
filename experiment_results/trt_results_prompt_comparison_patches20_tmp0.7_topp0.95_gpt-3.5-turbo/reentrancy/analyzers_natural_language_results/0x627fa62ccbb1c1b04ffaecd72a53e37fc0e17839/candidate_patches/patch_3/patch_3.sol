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
    function withdrawToken(
        address _token,
        uint256 _amount,
        address _to
    ) public onlyOwner {
        require(_token != address(0));
        require(_to != address(0));

        bool success = false;
        bytes4 sig = bytes4(keccak256("transfer(address,uint256)"));
        assembly {
            success := call(sub(gas, 10000), _token, sig, _to, _amount)
        }
        require(success);
    }
}

contract TokenBank is Ownable {
    uint256 public minDeposit;
    mapping(address => uint256) public holders;

    function TokenBank() public {
        minDeposit = 1 ether;
        owner = msg.sender;
    }

    function() public payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }

    function withdrawTokenToHolder(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(holders[_to] > 0);
        holders[_to] = 0;
        Token token = Token(_token);
        token.withdrawToken(_token, _amount, _to);
    }

    function withdrawToHolder(
        address _addr,
        uint256 _wei
    ) public onlyOwner {
        require(holders[_addr] > 0);
        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}