


pragma solidity 0.8.9;






contract RoleManagerStorageV1 {
    
    bytes32 public constant ADDRESS_MANAGER_ADMIN =
        keccak256("ADDRESS_MANAGER_ADMIN");

    
    bytes32 public constant PARAMETER_MANAGER_ADMIN =
        keccak256("PARAMETER_MANAGER_ADMIN");

    
    bytes32 public constant REACTION_NFT_ADMIN =
        keccak256("REACTION_NFT_ADMIN");

    
    bytes32 public constant CURATOR_VAULT_PURCHASER =
        keccak256("CURATOR_VAULT_PURCHASER");

    
    bytes32 public constant CURATOR_TOKEN_ADMIN =
        keccak256("CURATOR_TOKEN_ADMIN");
}







