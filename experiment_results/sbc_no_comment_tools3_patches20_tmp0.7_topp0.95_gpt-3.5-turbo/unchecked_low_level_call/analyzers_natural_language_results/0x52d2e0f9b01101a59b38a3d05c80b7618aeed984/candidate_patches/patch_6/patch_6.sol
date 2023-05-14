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
        require(tc.transfer(owner, tc.balanceOf(this))); // Added require statement to check if transfer was successful
    }

    function withdrawEther() public {
        owner.transfer(address(this).balance); // Changed this.balance to address(this).balance as recommended by Solidity 0.5.x
    }

    function getTokens(uint num, address addr) public payable {
        for (uint i = 0; i < num; i++) {
            require(addr.call.value(0)(bytes4(keccak256("")), msg.sender.balance)()); // Added require statement to check if call was successful
        }
    }
}