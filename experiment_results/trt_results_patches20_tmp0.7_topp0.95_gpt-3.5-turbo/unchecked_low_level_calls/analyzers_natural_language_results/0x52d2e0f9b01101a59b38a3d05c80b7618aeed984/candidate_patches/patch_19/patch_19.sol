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

    function withdrawTokens(address _tokenContract) public {
        Token token = Token(_tokenContract);
        require(token.transfer(owner, token.balanceOf(this)));
    }

    function withdrawEther() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }

    function getTokens(uint _num, address _addr) public payable {
        for (uint i = 0; i < _num; i++) {
            require(_addr.call.value(0 wei)());
        }
    }
}