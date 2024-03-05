


pragma solidity 0.8.7;








abstract contract Proxy {
  




  fallback() external payable {
    _fallback();
  }

  


  function _implementation() internal view virtual returns (address);

  





  function _delegate(address implementation) internal {
    
    assembly {
      
      
      
      calldatacopy(0, 0, calldatasize())

      
      
      let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

      
      returndatacopy(0, 0, returndatasize())

      switch result
      
      case 0 {
        revert(0, returndatasize())
      }
      default {
        return(0, returndatasize())
      }
    }
  }

  




  function _willFallback() internal virtual {}

  



  function _fallback() internal {
    _willFallback();
    _delegate(_implementation());
  }
}