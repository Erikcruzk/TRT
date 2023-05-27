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
        require(bonusCodes.length > 0, "No bonus code available");
        bonusCodes.length--;
    }
    
    function updateBonusCodeAt(uint idx, uint c) public {
        require(idx < bonusCodes.length, "Invalid index");
        bonusCodes[idx] = c;
    }
    
    function destroy() public {
        require(msg.sender == owner, "Only owner can call this function");
        selfdestruct(owner);
    }
}