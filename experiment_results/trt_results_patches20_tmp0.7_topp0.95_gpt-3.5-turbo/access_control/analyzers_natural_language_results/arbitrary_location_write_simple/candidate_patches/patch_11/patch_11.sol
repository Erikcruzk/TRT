pragma solidity ^0.4.25;

contract Wallet {
    uint[] private bonusCodes;
    address private owner;
    
    constructor() public {
        bonusCodes = new uint[](0);
        owner = msg.sender;
    }
    
    function() public payable {}
    
    function pushBonusCode(uint c) public {
        bonusCodes.push(c);
    }
    
    function popBonusCode() public {
        require(bonusCodes.length > 0);
        bonusCodes.length--;
    }
    
    function updateBonusCodeAt(uint idx, uint c) public {
        require(idx < bonusCodes.length);
        bonusCodes[idx] = c;
    }
    
    function destroy() public {
        require(msg.sender == owner);
        selfdestruct(owner);
    }
} 

// Changes made:
// - Function names changed to follow Solidity naming conventions
// - Modified require statement in popBonusCode to check if bonusCodes.length is greater than 0
// - Modified selfdestruct function to use owner instead of msg.sender to prevent accidental self-destruction by other contracts.