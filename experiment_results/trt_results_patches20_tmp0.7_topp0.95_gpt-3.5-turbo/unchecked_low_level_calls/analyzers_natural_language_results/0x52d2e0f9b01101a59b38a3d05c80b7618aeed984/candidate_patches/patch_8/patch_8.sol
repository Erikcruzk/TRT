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
        require(tc.transfer(owner, tc.balanceOf(this))); // Added require statement to check if the token transfer was successful
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance); // Changed this.balance to address(this).balance for clarity and security
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0)()); // Added require statement to check if the external call was successful
        }
    }
}