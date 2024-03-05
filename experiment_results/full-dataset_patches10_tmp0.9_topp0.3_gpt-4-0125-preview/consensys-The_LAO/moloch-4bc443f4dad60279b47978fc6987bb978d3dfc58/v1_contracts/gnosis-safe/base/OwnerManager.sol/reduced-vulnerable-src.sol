

pragma solidity ^0.5.0;




contract SelfAuthorized {
    modifier authorized() {
        require(msg.sender == address(this), "Method can only be called from this contract");
        _;
    }
}



pragma solidity ^0.5.0;




contract OwnerManager is SelfAuthorized {

    event AddedOwner(address owner);
    event RemovedOwner(address owner);
    event ChangedThreshold(uint256 threshold);

    address public constant SENTINEL_OWNERS = address(0x1);

    mapping(address => address) internal owners;
    uint256 ownerCount;
    uint256 internal threshold;

    
    
    
    function setupOwners(address[] memory _owners, uint256 _threshold)
        internal
    {
        
        
        require(threshold == 0, "Owners have already been setup");
        
        require(_threshold <= _owners.length, "Threshold cannot exceed owner count");
        
        require(_threshold >= 1, "Threshold needs to be greater than 0");
        
        address currentOwner = SENTINEL_OWNERS;
        for (uint256 i = 0; i < _owners.length; i++) {
            
            address owner = _owners[i];
            require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
            
            require(owners[owner] == address(0), "Duplicate owner address provided");
            owners[currentOwner] = owner;
            currentOwner = owner;
        }
        owners[currentOwner] = SENTINEL_OWNERS;
        ownerCount = _owners.length;
        threshold = _threshold;
    }

    
    
    
    
    function addOwnerWithThreshold(address owner, uint256 _threshold)
        public
        authorized
    {
        
        require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
        
        require(owners[owner] == address(0), "Address is already an owner");
        owners[owner] = owners[SENTINEL_OWNERS];
        owners[SENTINEL_OWNERS] = owner;
        ownerCount++;
        emit AddedOwner(owner);
        
        if (threshold != _threshold)
            changeThreshold(_threshold);
    }

    
    
    
    
    
    function removeOwner(address prevOwner, address owner, uint256 _threshold)
        public
        authorized
    {
        
        require(ownerCount - 1 >= _threshold, "New owner count needs to be larger than new threshold");
        
        require(owner != address(0) && owner != SENTINEL_OWNERS, "Invalid owner address provided");
        require(owners[prevOwner] == owner, "Invalid prevOwner, owner pair provided");
        owners[prevOwner] = owners[owner];
        owners[owner] = address(0);
        ownerCount--;
        emit RemovedOwner(owner);
        
        if (threshold != _threshold)
            changeThreshold(_threshold);
    }

    
    
    
    
    
    function swapOwner(address prevOwner, address oldOwner, address newOwner)
        public
        authorized
    {
        
        require(newOwner != address(0) && newOwner != SENTINEL_OWNERS, "Invalid owner address provided");
        
        require(owners[newOwner] == address(0), "Address is already an owner");
        
        require(oldOwner != address(0) && oldOwner != SENTINEL_OWNERS, "Invalid owner address provided");
        require(owners[prevOwner] == oldOwner, "Invalid prevOwner, owner pair provided");
        owners[newOwner] = owners[oldOwner];
        owners[prevOwner] = newOwner;
        owners[oldOwner] = address(0);
        emit RemovedOwner(oldOwner);
        emit AddedOwner(newOwner);
    }

    
    
    
    function changeThreshold(uint256 _threshold)
        public
        authorized
    {
        
        require(_threshold <= ownerCount, "Threshold cannot exceed owner count");
        
        require(_threshold >= 1, "Threshold needs to be greater than 0");
        threshold = _threshold;
        emit ChangedThreshold(threshold);
    }

    function getThreshold()
        public
        view
        returns (uint256)
    {
        return threshold;
    }

    function isOwner(address owner)
        public
        view
        returns (bool)
    {
        return owner != SENTINEL_OWNERS && owners[owner] != address(0);
    }

    
    
    function getOwners()
        public
        view
        returns (address[] memory)
    {
        address[] memory array = new address[](ownerCount);

        
        uint256 index = 0;
        address currentOwner = owners[SENTINEL_OWNERS];
        while(currentOwner != SENTINEL_OWNERS) {
            array[index] = currentOwner;
            currentOwner = owners[currentOwner];
            index ++;
        }
        return array;
    }
}