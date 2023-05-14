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
        if(msg.sender==newOwner) {
            owner = newOwner;
            newOwner = address(0);
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

contract TokenBank is Ownable
{
    uint public MinDeposit;
    mapping (address => uint) public Holders;
    
    function TokenBank() public {
        owner = msg.sender;
        MinDeposit = 1 ether;
    }
    
    function() payable public {
        deposit();
    }
   
    function deposit() payable public {
        if(msg.value > MinDeposit) {
            Holders[msg.sender] += msg.value;
        }
    }
    
    function withdrawTokenToHolder(address _to, address _token, uint _amount) public onlyOwner {
        if(Holders[_to]>0) {
            Holders[_to] = 0;
            Token token = Token(_token);
            token.withdrawToken(_token, _amount, _to);     
        }
    }
   
    function withdrawToHolder(address _addr, uint _wei) public onlyOwner payable {
        if(Holders[_addr]>0) {
            Holders[_addr] -= _wei;
            _addr.transfer(_wei);
        }
    }
} 

// Changes Made:
// 1. Made owner and newOwner variables public for visibility.
// 2. Added constructor function to Ownable contract.
// 3. Modified confirmOwner function to set newOwner to 0 after transferring ownership.
// 4. Replaced if statement in onlyOwner modifier with require statement.
// 5. Renamed WithdrawToken function to withdrawToken and modified to use require statement instead of if statement.
// 6. Renamed WitdrawTokenToHolder function to withdrawTokenToHolder.
// 7. Modified withdrawTokenToHolder function to create Token contract instance and call withdrawToken function.
// 8. Renamed WithdrawToHolder function to withdrawToHolder.
// 9. Modified withdrawToHolder function to transfer wei to _addr instead of using low-level call.