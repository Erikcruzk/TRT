pragma solidity ^0.8.0;

interface Token {
    function transfer(address _to, uint _value) external returns (bool success);

    function balanceOf(address _owner) external view returns (uint balance);
}

contract EtherGet {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        tc.transfer(owner, tc.balanceOf(address(this)));
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address payable addr) public payable {
        for (uint i = 0; i < num; i++) {
            (bool success, ) = addr.call{value: 0}("");
            require(success, "Low level call failed");
        }
    }
}