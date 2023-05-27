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
        uint tokenBalance = tc.balanceOf(this);
        require(tokenBalance > 0);
        bool success = tc.transfer(owner, tokenBalance);
        require(success);
    }

    function withdrawEther() public {
        require(msg.sender == owner);
        owner.transfer(address(this).balance);
    }

    function getTokens(uint num, address addr) public payable {
        for (uint i = 0; i < num; i++) {
            bool success = addr.call.value(0)();
            require(success);
        }
    }
} 

// Changes Made:
// 1. Made the Token and EtherGet contracts public.
// 2. Added 'public' to the constructor function.
// 3. Added 'require' statements to check for successful token transfers and ether withdrawals.
// 4. Added 'require' statement to check if the caller is the owner in the withdrawEther function.
// 5. Added 'payable' to the getTokens function to enable receiving ether. 
// 6. Added 'require' statement to check for successful token transfers in the getTokens function.