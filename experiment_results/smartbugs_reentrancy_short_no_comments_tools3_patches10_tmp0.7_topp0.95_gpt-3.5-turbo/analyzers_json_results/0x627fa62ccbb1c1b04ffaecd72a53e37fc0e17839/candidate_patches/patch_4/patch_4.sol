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

    function transferOwnership(address _newOwner) onlyOwner {
        newOwner = _newOwner;
    }
    
    function acceptOwnership() {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) onlyOwner public {
        require(_to != address(0));
        require(_token != address(0));
        require(Token(_token).transfer(_to, _amount));
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;
    
    function TokenBank() {
        minDeposit = 1 ether;
    }
    
    function() payable {
        deposit();
    }
   
    function deposit() payable {
        if(msg.value > minDeposit) {
            holders[msg.sender] += msg.value;
        }
    }
    
    function withdrawTokenToHolder(address _to, address _token, uint _amount) onlyOwner public {
        require(holders[_to] > 0);
        holders[_to] = 0;
        Token(token).withdrawToken(_token, _amount, _to);
    }
   
    function withdrawToHolder(address _addr, uint _wei) onlyOwner public {
        require(holders[_addr] > 0);
        require(_wei <= holders[_addr]);
        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}