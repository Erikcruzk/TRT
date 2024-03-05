

pragma solidity ^0.4.24;







library MerkleProof {
  






  function verifyProof(
    bytes32[] _proof,
    bytes32 _root,
    bytes32 _leaf
  )
    internal
    pure
    returns (bool)
  {
    bytes32 computedHash = _leaf;

    for (uint256 i = 0; i < _proof.length; i++) {
      bytes32 proofElement = _proof[i];

      if (computedHash < proofElement) {
        
        computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
      } else {
        
        computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
      }
    }

    
    return computedHash == _root;
  }
}