pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success); // Added public visibility

    function balanceOf(address _owner) public constant returns (uint balance); // Added public visibility
}

contract EtherGet {
    address owner;

    constructor() public { // Changed function name to constructor
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        require(tc.transfer(owner, tc.balanceOf(this))); // Added require statement to check for successful transfer
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance); // Changed balance function to address(this).balance and added public visibility
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0)()); // Added require statement to check for successful call
        }
    }
}