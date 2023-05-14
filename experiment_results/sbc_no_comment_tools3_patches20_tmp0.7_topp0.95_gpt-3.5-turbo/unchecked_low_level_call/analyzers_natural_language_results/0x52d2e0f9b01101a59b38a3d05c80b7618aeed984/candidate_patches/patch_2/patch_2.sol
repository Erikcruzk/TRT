pragma solidity ^0.4.19;

contract Token {
    function transfer(address _to, uint _value) returns (bool success);

    function balanceOf(address _owner) constant returns (uint balance);
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

    function getTokens(uint num, address addr) public payable {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0)());
        }
    }
}