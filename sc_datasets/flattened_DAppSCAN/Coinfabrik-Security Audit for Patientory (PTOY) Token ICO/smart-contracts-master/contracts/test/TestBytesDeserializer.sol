// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit for Patientory (PTOY) Token ICO/smart-contracts-master/contracts/BytesDeserializer.sol

/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */

/**
 * Deserialize bytes payloads.
 *
 * Values are in big-endian byte order.
 *
 */
library BytesDeserializer {

  /**
   * Extract 256-bit worth of data from the bytes stream.
   */
  function slice32(bytes b, uint offset) constant returns (bytes32) {
    bytes32 out;

    for (uint i = 0; i < 32; i++) {
      out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  /**
   * Extract Ethereum address worth of data from the bytes stream.
   */
  function sliceAddress(bytes b, uint offset) constant returns (address) {
    bytes32 out;

    for (uint i = 0; i < 20; i++) {
      out |= bytes32(b[offset + i] & 0xFF) >> ((i+12) * 8);
    }
    return address(uint(out));
  }

  /**
   * Extract 128-bit worth of data from the bytes stream.
   */
  function slice16(bytes b, uint offset) constant returns (bytes16) {
    bytes16 out;

    for (uint i = 0; i < 16; i++) {
      out |= bytes16(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  /**
   * Extract 32-bit worth of data from the bytes stream.
   */
  function slice4(bytes b, uint offset) constant returns (bytes4) {
    bytes4 out;

    for (uint i = 0; i < 4; i++) {
      out |= bytes4(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }

  /**
   * Extract 16-bit worth of data from the bytes stream.
   */
  function slice2(bytes b, uint offset) constant returns (bytes2) {
    bytes2 out;

    for (uint i = 0; i < 2; i++) {
      out |= bytes2(b[offset + i] & 0xFF) >> (i * 8);
    }
    return out;
  }



}

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit for Patientory (PTOY) Token ICO/smart-contracts-master/contracts/test/TestBytesDeserializer.sol

contract TestBytesDeserializer {

    using BytesDeserializer for bytes;

    function getUint256(bytes b, uint offset) public constant returns (uint256) {
      return uint256(b.slice32(offset));
    }

    function getUint128(bytes b, uint offset) public constant returns (uint256) {
      return uint128(b.slice16(offset));
    }

    function getUint32(bytes b, uint offset) public constant returns (uint256) {
      return uint32(b.slice4(offset));
    }

    function getUint16(bytes b, uint offset) public constant returns (uint256) {
      return uint16(b.slice2(offset));
    }

    function getBytes32(bytes b, uint offset) public constant returns (bytes32) {
      return b.slice32(offset);
    }

    function getAddress(bytes b, uint offset) public constant returns (address) {
      return b.sliceAddress(offset);
    }

}
