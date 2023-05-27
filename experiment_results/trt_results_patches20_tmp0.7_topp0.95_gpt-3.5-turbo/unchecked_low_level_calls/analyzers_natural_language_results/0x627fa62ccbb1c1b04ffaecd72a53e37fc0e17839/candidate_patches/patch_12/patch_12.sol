pragma solidity ^0.4.19;

contract Ownable {
    address public owner;
    address public newOwner;
    
    function Ownable() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    function changeOwner(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    
    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token is Ownable {
    
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_token != address(0));
        require(_to != address(0));
        
        // Check if the _token contract is a valid ERC20 token
        require(ERC20(_token).transfer(_to, _amount));
    }
}

contract TokenBank is Ownable {
    uint public MinDeposit;
    mapping (address => uint) public Holders;
    
    function TokenBank() public {
        MinDeposit = 1 ether;
    }
    
    function() public payable {
        deposit();
    }
   
    function deposit() public payable {
        if(msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }
    
    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(Holders[_to] > 0);
        Holders[_to] = 0;
        Token token = Token(_token);
        token.withdrawToken(_token, _amount, _to);
    }
   
    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(Holders[_addr] > 0);
        Holders[_addr] -= _wei;
        require(_addr.send(_wei));
    }
}

interface ERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
}