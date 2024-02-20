

pragma solidity ^0.4.24;

contract TwoKeyConverterStates {
    enum ConverterState {NOT_EXISTING, PENDING_APPROVAL, APPROVED, REJECTED}

    
    
    
    function convertConverterStateToBytes(
        ConverterState state
    )
    internal
    pure
    returns (bytes32)
    {
        if(ConverterState.NOT_EXISTING == state) {
            return bytes32("NOT_EXISTING");
        }
        else if(ConverterState.PENDING_APPROVAL == state) {
            return bytes32("PENDING_APPROVAL");
        }
        else if(ConverterState.APPROVED == state) {
            return bytes32("APPROVED");
        }
        else if(ConverterState.REJECTED == state) {
            return bytes32("REJECTED");
        }
    }
}



pragma solidity ^0.4.24;





contract ITwoKeyConversionHandlerGetConverterState {
    function getStateForConverter(address _converter) public view returns (bytes32);
}