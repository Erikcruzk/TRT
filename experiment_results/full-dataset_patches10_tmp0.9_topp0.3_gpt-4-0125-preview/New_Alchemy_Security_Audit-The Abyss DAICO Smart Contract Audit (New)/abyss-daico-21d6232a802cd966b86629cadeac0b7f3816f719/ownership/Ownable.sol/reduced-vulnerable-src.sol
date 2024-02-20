

pragma solidity ^0.4.21;






contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address previousOwner, address newOwner);

    


    function Ownable(address _owner) public {
        owner = _owner == address(0) ? msg.sender : _owner;
    }

    


    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    



    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != owner);
        newOwner = _newOwner;
    }

    


    function confirmOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = 0x0;
    }
}