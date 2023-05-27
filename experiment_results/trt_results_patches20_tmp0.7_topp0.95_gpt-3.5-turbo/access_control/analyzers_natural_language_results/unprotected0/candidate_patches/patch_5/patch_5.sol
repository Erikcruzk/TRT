pragma solidity ^0.4.15;

contract Protected {
    address private owner;

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }

    function Protected() public {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyowner {
        require(_newOwner != address(0)); // added to prevent owner being set to null address
        owner = _newOwner;
    }
}