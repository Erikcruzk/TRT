pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success); // Added public visibility

    function balanceOf(address _owner) public constant returns (uint balance); // Added public visibility
}

contract EtherGet {
    address owner;

    function EtherGet() public {
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        tc.transfer(owner, tc.balanceOf(this));
    }

    function withdrawEther() public {
        owner.transfer(this.balance);
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0 wei)()); // Added require statement to check for successful low-level call
        }
    }
}