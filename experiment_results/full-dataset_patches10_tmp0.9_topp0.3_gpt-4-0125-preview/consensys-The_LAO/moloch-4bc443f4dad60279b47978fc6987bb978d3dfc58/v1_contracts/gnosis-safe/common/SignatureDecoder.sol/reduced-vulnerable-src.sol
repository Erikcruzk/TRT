

pragma solidity ^0.5.0;





contract SignatureDecoder {
    
    
    
    
    
    function recoverKey (
        bytes32 messageHash, 
        bytes memory messageSignature,
        uint256 pos
    )
        internal
        pure
        returns (address) 
    {
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v, r, s) = signatureSplit(messageSignature, pos);
        return ecrecover(messageHash, v, r, s);
    }

    
    
    
    
    function signatureSplit(bytes memory signatures, uint256 pos)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        
        
        
        
        assembly {
            let signaturePos := mul(0x41, pos)
            r := mload(add(signatures, add(signaturePos, 0x20)))
            s := mload(add(signatures, add(signaturePos, 0x40)))
            
            
            
            
            
            v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
        }
    }
}