pragma solidity ^0.4.19;

contract Ownable {
    address public owner;
    address public newOwner;

    function Ownable() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, address _to, uint256 _amount) public onlyOwner {
        require(_token.call(bytes4(keccak256("transfer(address,uint256)")), _to, _amount));
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;

    function TokenBank() {
        minDeposit = 1 ether;
    }

    function () payable {
        deposit();
    }

    function deposit() payable {
        if (msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }

    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if (holders[_to] > 0) {
            holders[_to] = 0;
            Token token = Token(_token);
            token.withdrawToken(_token, _to, _amount);
        }
    }

    function withdrawToHolder(address _to, uint _amount) public onlyOwner {
        require(holders[_to] >= _amount);
        holders[_to] -= _amount;
        require(_to.call.value(_amount)());
    }
}