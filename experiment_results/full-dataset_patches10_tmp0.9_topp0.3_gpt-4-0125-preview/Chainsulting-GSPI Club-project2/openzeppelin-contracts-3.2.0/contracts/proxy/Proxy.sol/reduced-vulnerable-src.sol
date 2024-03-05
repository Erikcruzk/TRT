



pragma solidity ^0.6.0;











abstract contract Proxy {
    




    function _delegate(address implementation) internal {
        
        assembly {
            
            
            
            calldatacopy(0, 0, calldatasize())

            
            
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            
            returndatacopy(0, 0, returndatasize())

            switch result
            
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    



    function _implementation() internal virtual view returns (address);

    




    function _fallback() internal {
        _beforeFallback();
        _delegate(_implementation());
    }

    



    fallback () payable external {
        _fallback();
    }

    



    receive () payable external {
        _fallback();
    }

    





    function _beforeFallback() internal virtual {
    }
}