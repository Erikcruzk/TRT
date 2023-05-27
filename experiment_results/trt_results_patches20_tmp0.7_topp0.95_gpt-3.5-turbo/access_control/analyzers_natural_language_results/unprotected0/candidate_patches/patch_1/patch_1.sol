pragma solidity ^0.4.15;

contract Protected {
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function Protected() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
} 

// The contract has been renamed to Protected and the onlyowner modifier has been changed to onlyOwner. Additionally, a getOwner function has been added to allow for retrieving the current owner's address.