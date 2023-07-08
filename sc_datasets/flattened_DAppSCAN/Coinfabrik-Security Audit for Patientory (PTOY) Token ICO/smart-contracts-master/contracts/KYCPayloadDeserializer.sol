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

// File: ../sc_datasets/DAppSCAN/Coinfabrik-Security Audit for Patientory (PTOY) Token ICO/smart-contracts-master/contracts/KYCPayloadDeserializer.sol

/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */

/**
 * A mix-in contract to decode different signed KYC payloads.
 *
 * @notice This should be a library, but for the complexity and toolchain fragility risks involving of linking library inside library, we currently use this as a helper method mix-in.
 */
contract KYCPayloadDeserializer {

  using BytesDeserializer for bytes;

  // @notice this struct describes what kind of data we include in the payload, we do not use this directly
  // The bytes payload set on the server side
  // total 56 bytes
  struct KYCPayload {

    /** Customer whitelisted address where the deposit can come from */
    address whitelistedAddress; // 20 bytes

    /** Customer id, UUID v4 */
    uint128 customerId; // 16 bytes

    /**
     * Min amount this customer needs to invest in ETH. Set zero if no minimum. Expressed as parts of 10000. 1 ETH = 10000.
     * @notice Decided to use 32-bit words to make the copy-pasted Data field for the ICO transaction less lenghty.
     */
    uint32 minETH; // 4 bytes

    /** Max amount this customer can to invest in ETH. Set zero if no maximum. Expressed as parts of 10000. 1 ETH = 10000. */
    uint32 maxETH; // 4 bytes

    /**
     * Information about the price promised for this participant. It can be pricing tier id or directly one token price in weis.
     * @notice This is a later addition and not supported in all scenarios yet.
     */
    uint256 pricingInfo;
  }


  /**
   * Same as above, but with pricing information included in the payload as the last integer.
   *
   * @notice In a long run, deprecate the legacy methods above and only use this payload.
   */
  function getKYCPayload(bytes dataframe) public constant returns(address whitelistedAddress, uint128 customerId, uint32 minEth, uint32 maxEth, uint256 pricingInfo) {
    address _whitelistedAddress = dataframe.sliceAddress(0);
    uint128 _customerId = uint128(dataframe.slice16(20));
    uint32 _minETH = uint32(dataframe.slice4(36));
    uint32 _maxETH = uint32(dataframe.slice4(40));
    uint256 _pricingInfo = uint256(dataframe.slice32(44));
    return (_whitelistedAddress, _customerId, _minETH, _maxETH, _pricingInfo);
  }

}
