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

// Changes Made:
// 1. Changed function names to follow Solidity naming conventions (camelCase).
// 2. Added a check in 'popBonusCode' function to ensure that there is at least one bonus code to pop.
// 3. Changed 'selfdestruct(msg.sender)' to 'selfdestruct(owner)' to avoid potential issues with sending funds to the wrong address.