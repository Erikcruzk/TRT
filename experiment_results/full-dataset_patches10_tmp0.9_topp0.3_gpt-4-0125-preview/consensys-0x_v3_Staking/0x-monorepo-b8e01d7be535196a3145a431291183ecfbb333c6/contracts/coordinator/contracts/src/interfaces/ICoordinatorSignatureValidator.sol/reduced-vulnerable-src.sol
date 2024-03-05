



















pragma solidity ^0.5.9;


contract ICoordinatorSignatureValidator {

   
    enum SignatureType {
        Illegal,                
        Invalid,                
        EIP712,                 
        EthSign,                
        Wallet,                 
        Validator,              
        PreSigned,              
        OrderValidator,         
        WalletOrderValidator,   
        NSignatureTypes         
    }

    
    
    
    function getSignerAddress(bytes32 hash, bytes memory signature)
        public
        pure
        returns (address signerAddress);
}