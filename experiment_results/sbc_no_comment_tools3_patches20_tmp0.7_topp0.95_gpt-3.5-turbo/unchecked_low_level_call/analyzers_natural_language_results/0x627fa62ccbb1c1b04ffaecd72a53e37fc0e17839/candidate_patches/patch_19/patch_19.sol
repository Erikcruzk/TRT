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
    function withdrawToken(address token, uint256 amount, address to)
    public 
    onlyOwner
    {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token
{
    uint public MinDeposit;
    mapping (address => uint) public Holders;