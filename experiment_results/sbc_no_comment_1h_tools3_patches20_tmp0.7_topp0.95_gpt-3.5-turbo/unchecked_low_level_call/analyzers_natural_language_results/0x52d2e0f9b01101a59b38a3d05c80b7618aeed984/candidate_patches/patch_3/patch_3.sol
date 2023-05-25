pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success);

    function balanceOf(address _owner) public constant returns (uint balance);
}

contract EtherGet {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        uint balance = tc.balanceOf(this);
        require(balance > 0);
        bool success = tc.transfer(owner, balance);
        require(success);
    }

    function withdrawEther() public {
        require(msg.sender == owner);
        msg.sender.transfer(this.balance);
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            bool success = addr.call.value(0)();
            require(success);
        }
    }
}