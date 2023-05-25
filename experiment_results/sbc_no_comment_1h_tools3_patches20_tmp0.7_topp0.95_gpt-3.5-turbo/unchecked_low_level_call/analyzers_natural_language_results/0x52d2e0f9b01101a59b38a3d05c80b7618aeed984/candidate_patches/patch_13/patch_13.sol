pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success);
    function balanceOf(address _owner) public constant returns (uint balance);
}

contract EtherGet {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public returns (bool success) {
        Token tc = Token(tokenContract);
        uint balance = tc.balanceOf(address(this));
        if (balance > 0) {
            success = tc.transfer(owner, balance);
        }
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address addr) public returns (bool success) {
        for (uint i = 0; i < num; i++) {
            success = addr.call.value(0)();
            require(success);
        }
    }
}

// Changes Made:
// - Added public modifier to functions
// - Added returns statement to withdrawTokens function
// - Added require statement to getTokens function to check for successful external call
// - Changed constructor function name to match contract name and added public modifier
// - Added uint balance variable to withdrawTokens function to check for non-zero balance before transferring tokens
// - Changed this.balance to address(this).balance in withdrawEther function for consistency and safety reasons