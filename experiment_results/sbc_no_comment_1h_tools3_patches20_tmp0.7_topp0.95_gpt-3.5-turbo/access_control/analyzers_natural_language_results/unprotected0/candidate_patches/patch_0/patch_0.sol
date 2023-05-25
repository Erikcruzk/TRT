pragma solidity ^0.4.15;

contract Protected {
    address private owner;

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyowner {
        owner = _newOwner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}