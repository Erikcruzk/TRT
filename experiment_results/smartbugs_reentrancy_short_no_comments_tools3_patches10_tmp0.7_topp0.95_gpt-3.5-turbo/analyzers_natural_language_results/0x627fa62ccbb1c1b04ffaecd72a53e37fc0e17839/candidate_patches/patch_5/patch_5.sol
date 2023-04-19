pragma solidity ^0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }
    
    function changeOwner(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner address cannot be zero.");
        newOwner = _newOwner;
    }
    
    function confirmOwner() public {
        require(msg.sender == newOwner, "Only the new owner can call this function.");
        owner = newOwner;
        newOwner = address(0);
    }
}

interface ERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract Token is Ownable {
    function withdrawToken(address _token, uint256 _amount, address _to) public onlyOwner {
        ERC20(_token).transfer(_to, _amount);
    }
}

contract TokenBank is Ownable {
    uint public minDeposit;
    mapping (address => uint) public holders;
    
    constructor() {
        minDeposit = 1 ether;
    }
    
    receive() external payable {
        deposit();
    }
   
    function deposit() public payable {
        require(msg.value > minDeposit, "Deposit amount must be greater than the minimum deposit.");
        holders[msg.sender] += msg.value;
    }
    
    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        require(holders[_to] > 0, "Holder must have a balance greater than zero.");
        holders[_to] = 0;
        Token.withdrawToken(_token, _amount, _to);     
    }
   
    function withdrawToHolder(address _addr, uint _wei) public onlyOwner {
        require(holders[_addr] > 0, "Holder must have a balance greater than zero.");
        require(address(this).balance >= _wei, "Contract balance is insufficient to complete the withdrawal.");
        holders[_addr] -= _wei;
        (bool success, ) = _addr.call{value: _wei}("");
        require(success, "Withdrawal failed.");
    }
}