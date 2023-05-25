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

    function withdrawTokens(address tokenContract) public returns(bool success) {
        Token tc = Token(tokenContract);
        uint balance = tc.balanceOf(address(this));
        if(balance == 0) {
            return false;
        }
        bool transferSuccess = tc.transfer(owner, balance);
        if(!transferSuccess) {
            return false;
        }
        return true;
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address addr) public returns(bool success) {
        for (uint i = 0; i < num; i++) {
            bool callSuccess = addr.call.value(0 wei)();
            if(!callSuccess) {
                return false;
            }
        }
        return true;
    }
}