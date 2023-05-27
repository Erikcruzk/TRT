pragma solidity ^0.4.24;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success);
    function balanceOf(address _owner) public view returns (uint balance);
}

contract EtherGet {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        uint balance = tc.balanceOf(address(this));
        require(balance > 0, "Token balance must be greater than zero");
        require(tc.transfer(owner, balance), "Transfer of tokens failed");
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0)(), "Token transfer failed");
        }
    }
}