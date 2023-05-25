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
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            bool success = addr.call.value(0 wei)();
            require(success);
        }
    }
} 

// Changes Made:
// 1. Made the functions "public" to make them accessible from outside the contract.
// 2. Added "constructor" instead of using the old way of defining the constructor.
// 3. Added "require" statements to check for success of external calls and to check for balance before transfer.
// 4. Used "address(this).balance" instead of "this.balance" in withdrawEther function as "this.balance" is deprecated.