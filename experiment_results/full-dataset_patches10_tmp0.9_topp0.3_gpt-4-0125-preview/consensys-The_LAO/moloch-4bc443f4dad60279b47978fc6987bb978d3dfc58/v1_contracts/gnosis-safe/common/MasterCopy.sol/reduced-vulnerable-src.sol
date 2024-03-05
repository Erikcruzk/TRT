

pragma solidity ^0.5.0;




contract SelfAuthorized {
    modifier authorized() {
        require(msg.sender == address(this), "Method can only be called from this contract");
        _;
    }
}



pragma solidity ^0.5.0;



contract MasterCopy is SelfAuthorized {
  
  
    address masterCopy;

  
  
    function changeMasterCopy(address _masterCopy)
        public
        authorized
    {
        
        require(_masterCopy != address(0), "Invalid master copy address provided");
        masterCopy = _masterCopy;
    }
}