


pragma solidity >=0.5.0;


interface IMerkleDistributor {
    
    function merkleRoot() external view returns (bytes32);
    
    function claim(uint256 index, address account, bool isValid, bytes32[] calldata merkleProof) external view;
}