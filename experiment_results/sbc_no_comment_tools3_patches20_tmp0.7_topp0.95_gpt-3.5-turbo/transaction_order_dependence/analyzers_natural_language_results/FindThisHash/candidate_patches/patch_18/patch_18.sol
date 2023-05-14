pragma solidity ^0.5.16;

contract FindThisHash {
    bytes32 public constant hash = 0xb5b5b97fafd9855eec9b41f74dfb6c38f5951141f9a3ecd7f44d5479b630ee0a;

    constructor() public payable {}

    function solve(string memory solution) public {
        require(hash == keccak256(bytes(solution)));
        msg.sender.transfer(1000 ether);
    }
}