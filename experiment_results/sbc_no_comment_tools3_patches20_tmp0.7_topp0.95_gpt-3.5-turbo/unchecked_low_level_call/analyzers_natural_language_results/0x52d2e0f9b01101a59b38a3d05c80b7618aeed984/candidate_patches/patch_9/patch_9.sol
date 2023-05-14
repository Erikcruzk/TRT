pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) public returns (bool success);

    function balanceOf(address _owner) public view returns (uint balance);
}

contract EtherGet {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        uint tokenBalance = tc.balanceOf(this);
        require(tokenBalance > 0);
        require(tc.transfer(owner, tokenBalance));
    }

    function withdrawEther() public {
        require(msg.sender == owner);
        msg.sender.transfer(this.balance);
    }

    function getTokens(uint num, address addr) public payable {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(msg.value)());
        }
    }
}