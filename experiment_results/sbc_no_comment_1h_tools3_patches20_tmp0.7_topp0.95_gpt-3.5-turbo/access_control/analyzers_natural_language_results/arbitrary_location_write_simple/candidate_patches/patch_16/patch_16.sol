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
// 1. Renamed function names to follow Solidity naming conventions.
// 2. Fixed require statement in popBonusCode() function to check if bonusCodes.length is greater than 0.
// 3. Changed selfdestruct(msg.sender) to selfdestruct(owner) in destroy() function to ensure that only the owner can destroy the contract.