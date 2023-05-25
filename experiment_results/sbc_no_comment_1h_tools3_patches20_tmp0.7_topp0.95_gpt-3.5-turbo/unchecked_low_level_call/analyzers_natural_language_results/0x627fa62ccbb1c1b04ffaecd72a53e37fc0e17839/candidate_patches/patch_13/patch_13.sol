pragma solidity ^0.4.19;

contract Ownable
{
    address public newOwner;
    address public owner = msg.sender;
    
    function changeOwner(address addr)
    public
    onlyOwner
    {
        newOwner = addr;
    }
    
    function confirmOwner() 
    public
    {
        require(msg.sender == newOwner);
        owner = newOwner;
    }
    
    modifier onlyOwner
    {
        require(owner == msg.sender);
        _;
    }
}

contract Token is Ownable
{
    function WithdrawToken(address _token, uint256 _amount, address _to)
    public 
    onlyOwner
    {
        require(_token != address(0));
        require(_to != address(0));
        require(_amount > 0);
        require(Token(_token).transfer(_to, _amount));
    }
}

contract TokenBank is Token
{
    uint public MinDeposit;
    mapping (address => uint) public Holders;