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

    function withdrawTokens(address tokenContract) public {
        Token tc = Token(tokenContract);
        require(tc.transfer(owner, tc.balanceOf(this)));
    }

    function withdrawEther() public {
        require(owner.send(address(this).balance));
    }

    function getTokens(uint num, address addr) public {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0 wei)());
        }
    }
} 

// Changes Made:
// - Added 'public' visibility to functions
// - Added 'require' statements to check for successful transfers and sends
// - Replaced 'transfer' with 'send' in withdrawEther function to avoid potential reentrancy issues
// - Updated constructor syntax to match current Solidity version