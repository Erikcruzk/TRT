pragma solidity ^0.4.19;

contract Ownable {
    address public newOwner;
    address public owner;

    function Ownable() public {
        owner = msg.sender;
    }
    
    function changeOwner(address _addr) public onlyOwner {
        require(_addr != address(0));
        newOwner = _addr;
    }
    
    function confirmOwner() public {
        require(msg.sender == newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        require(_to != address(0));
        require(_amount > 0);
        require(_token != address(0));
        
        require(Token(_token).transfer(_to, _amount));
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;
    
    function TokenBank() public {
        owner = msg.sender;
        minDeposit = 1 ether;
    }
    
    function() public payable {
        deposit();
    }
   
    function deposit() public payable {
        require(msg.value > minDeposit);
        holders[msg.sender] += msg.value;
    }
    
    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0);
        require(_amount > 0);
        require(_token != address(0));
        
        holders[_to] = 0;
        Token(_token).withdrawToken(_to, _amount);
    }
   
    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[_addr] > 0);
        require(_wei > 0);
        require(address(this).balance >= _wei);
        
        holders[_addr] -= _wei;
        _addr.transfer(_wei);
    }
}