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

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        uint tokenBalance = tc.balanceOf(address(this));
        require(tokenBalance > 0);
        bool transferSuccess = tc.transfer(owner, tokenBalance);
        require(transferSuccess);
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0)());
        }
    }
} 

// Changes made:
// 1. Made the constructor function explicit
// 2. Made all functions explicitly public
// 3. Checked for non-zero token balance before transferring tokens in withdrawTokens function
// 4. Checked for successful token transfer in withdrawTokens function
// 5. Checked for successful external call in getTokens function and added require statement to revert transaction if call fails.