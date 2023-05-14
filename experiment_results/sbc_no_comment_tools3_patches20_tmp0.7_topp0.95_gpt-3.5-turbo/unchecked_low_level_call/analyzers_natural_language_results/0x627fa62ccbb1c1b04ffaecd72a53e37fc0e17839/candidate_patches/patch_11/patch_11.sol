pragma solidity ^0.4.19;

contract Ownable
{
    address public newOwner;
    address public owner;
    
    function Ownable() public {
        owner = msg.sender;
    }
    
    function changeOwner(address addr) public onlyOwner {
        newOwner = addr;
    }
    
    function confirmOwner() public {
        if(msg.sender == newOwner) {
            owner = newOwner;
        }
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}

contract Token is Ownable
{
    function withdrawToken(address token, uint256 amount, address to) public onlyOwner {
        require(token.call(bytes4(keccak256("transfer(address,uint256)")), to, amount));
    }
}

contract TokenBank is Token
{
    uint public minDeposit;
    mapping (address => uint) public holders;