


pragma solidity 0.6.12;














contract HoldefiOwnable {
    address public owner;
    address public pendingOwner;

    
    event OwnershipTransferRequested(address newPendingOwner);

    
    event OwnershipTransferred(address newOwner, address oldOwner);

    
    constructor () public {
        owner = msg.sender;
        emit OwnershipTransferred(owner, address(0));
    }

    
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender should be owner");
        _;
    }

    
    
    
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner can not be zero address");
        pendingOwner = newOwner;

        emit OwnershipTransferRequested(newOwner);
    }

    
    
    function acceptTransferOwnership () external {
        require (pendingOwner != address(0), "Pending owner is empty");
        require (pendingOwner == msg.sender, "Pending owner is not same as sender");
        
        emit OwnershipTransferred(pendingOwner, owner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}