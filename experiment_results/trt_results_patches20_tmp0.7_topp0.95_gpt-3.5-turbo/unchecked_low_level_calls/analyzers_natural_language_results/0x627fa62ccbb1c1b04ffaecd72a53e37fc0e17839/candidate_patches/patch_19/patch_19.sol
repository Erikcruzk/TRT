pragma solidity ^0.4.19;

contract Ownable
{
    address public newOwner; // make newOwner public
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
        require(msg.sender == newOwner); // use require statement instead of if statement
        owner = newOwner;
    }
    
    modifier onlyOwner
    {
        require(owner == msg.sender); // use require statement instead of if statement
        _;
    }
}

contract Token is Ownable
{
    function WithdrawToken(address token, uint256 amount,address to)
    public 
    onlyOwner
    {
         require(token.call(bytes4(keccak256("transfer(address,uint256)")),to,amount)); // add require statement to check return value of external call
    }
}

contract TokenBank is Token
{
    uint public MinDeposit;
    mapping (address => uint) public Holders;