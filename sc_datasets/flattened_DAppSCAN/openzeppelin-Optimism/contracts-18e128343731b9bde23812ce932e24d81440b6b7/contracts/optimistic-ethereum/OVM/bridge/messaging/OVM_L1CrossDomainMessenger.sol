// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/rlp/Lib_RLPReader.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title Lib_RLPReader
 * @dev Adapted from "RLPReader" by Hamdi Allam (hamdi.allam97@gmail.com).
 */
library Lib_RLPReader {

    /*************
     * Constants *
     *************/

    uint256 constant internal MAX_LIST_LENGTH = 32;


    /*********
     * Enums *
     *********/

    enum RLPItemType {
        DATA_ITEM,
        LIST_ITEM
    }

    
    /***********
     * Structs *
     ***********/

    struct RLPItem {
        uint256 length;
        uint256 ptr;
    }
    

    /**********************
     * Internal Functions *
     **********************/
    
    /**
     * Converts bytes to a reference to memory position and length.
     * @param _in Input bytes to convert.
     * @return Output memory reference.
     */
    function toRLPItem(
        bytes memory _in
    )
        internal
        pure
        returns (
            RLPItem memory
        )
    {
        uint256 ptr;
        assembly {
            ptr := add(_in, 32)
        }

        return RLPItem({
            length: _in.length,
            ptr: ptr
        });
    }

    /**
     * Reads an RLP list value into a list of RLP items.
     * @param _in RLP list value.
     * @return Decoded RLP list items.
     */
    function readList(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            RLPItem[] memory
        )
    {
        (
            uint256 listOffset,
            ,
            RLPItemType itemType
        ) = _decodeLength(_in);

        require(
            itemType == RLPItemType.LIST_ITEM,
            "Invalid RLP list value."
        );

        // Solidity in-memory arrays can't be increased in size, but *can* be decreased in size by
        // writing to the length. Since we can't know the number of RLP items without looping over
        // the entire input, we'd have to loop twice to accurately size this array. It's easier to
        // simply set a reasonable maximum list length and decrease the size before we finish.
        RLPItem[] memory out = new RLPItem[](MAX_LIST_LENGTH);

        uint256 itemCount = 0;
        uint256 offset = listOffset;
        while (offset < _in.length) {
            require(
                itemCount < MAX_LIST_LENGTH,
                "Provided RLP list exceeds max list length."
            );

            (
                uint256 itemOffset,
                uint256 itemLength,
            ) = _decodeLength(RLPItem({
                length: _in.length - offset,
                ptr: _in.ptr + offset
            }));

            out[itemCount] = RLPItem({
                length: itemLength + itemOffset,
                ptr: _in.ptr + offset
            });

            itemCount += 1;
            offset += itemOffset + itemLength;
        }

        // Decrease the array size to match the actual item count.
        assembly {
            mstore(out, itemCount)
        }

        return out;
    }

    /**
     * Reads an RLP list value into a list of RLP items.
     * @param _in RLP list value.
     * @return Decoded RLP list items.
     */
    function readList(
        bytes memory _in
    )
        internal
        pure
        returns (
            RLPItem[] memory
        )
    {
        return readList(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP bytes value into bytes.
     * @param _in RLP bytes value.
     * @return Decoded bytes.
     */
    function readBytes(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        (
            uint256 itemOffset,
            uint256 itemLength,
            RLPItemType itemType
        ) = _decodeLength(_in);

        require(
            itemType == RLPItemType.DATA_ITEM,
            "Invalid RLP bytes value."
        );

        return _copy(_in.ptr, itemOffset, itemLength);
    }

    /**
     * Reads an RLP bytes value into bytes.
     * @param _in RLP bytes value.
     * @return Decoded bytes.
     */
    function readBytes(
        bytes memory _in
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return readBytes(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP string value into a string.
     * @param _in RLP string value.
     * @return Decoded string.
     */
    function readString(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            string memory
        )
    {
        return string(readBytes(_in));
    }

    /**
     * Reads an RLP string value into a string.
     * @param _in RLP string value.
     * @return Decoded string.
     */
    function readString(
        bytes memory _in
    )
        internal
        pure
        returns (
            string memory
        )
    {
        return readString(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP bytes32 value into a bytes32.
     * @param _in RLP bytes32 value.
     * @return Decoded bytes32.
     */
    function readBytes32(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        require(
            _in.length <= 33,
            "Invalid RLP bytes32 value."
        );

        (
            uint256 itemOffset,
            uint256 itemLength,
            RLPItemType itemType
        ) = _decodeLength(_in);

        require(
            itemType == RLPItemType.DATA_ITEM,
            "Invalid RLP bytes32 value."
        );

        uint256 ptr = _in.ptr + itemOffset;
        bytes32 out;
        assembly {
            out := mload(ptr)

            // Shift the bytes over to match the item size.
            if lt(itemLength, 32) {
                out := div(out, exp(256, sub(32, itemLength)))
            }
        }

        return out;
    }

    /**
     * Reads an RLP bytes32 value into a bytes32.
     * @param _in RLP bytes32 value.
     * @return Decoded bytes32.
     */
    function readBytes32(
        bytes memory _in
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return readBytes32(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP uint256 value into a uint256.
     * @param _in RLP uint256 value.
     * @return Decoded uint256.
     */
    function readUint256(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            uint256
        )
    {
        return uint256(readBytes32(_in));
    }

    /**
     * Reads an RLP uint256 value into a uint256.
     * @param _in RLP uint256 value.
     * @return Decoded uint256.
     */
    function readUint256(
        bytes memory _in
    )
        internal
        pure
        returns (
            uint256
        )
    {
        return readUint256(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP bool value into a bool.
     * @param _in RLP bool value.
     * @return Decoded bool.
     */
    function readBool(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            bool
        )
    {
        require(
            _in.length == 1,
            "Invalid RLP boolean value."
        );

        uint256 ptr = _in.ptr;
        uint256 out;
        assembly {
            out := byte(0, mload(ptr))
        }

        return out != 0;
    }

    /**
     * Reads an RLP bool value into a bool.
     * @param _in RLP bool value.
     * @return Decoded bool.
     */
    function readBool(
        bytes memory _in
    )
        internal
        pure
        returns (
            bool
        )
    {
        return readBool(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP address value into a address.
     * @param _in RLP address value.
     * @return Decoded address.
     */
    function readAddress(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            address
        )
    {
        if (_in.length == 1) {
            return address(0);
        }

        require(
            _in.length == 21,
            "Invalid RLP address value."
        );

        return address(readUint256(_in));
    }

    /**
     * Reads an RLP address value into a address.
     * @param _in RLP address value.
     * @return Decoded address.
     */
    function readAddress(
        bytes memory _in
    )
        internal
        pure
        returns (
            address
        )
    {
        return readAddress(
            toRLPItem(_in)
        );
    }

    /**
     * Reads an RLP Uint64 value into a uint64.
     * @param _in RLP uint64 value.
     * @return Decoded uint64.
     */
    function readUint64(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            uint64
        )
    {
        require(
            _in.length <= 9,
            "Invalid RLP uint64 value."
        );

        return uint64(readUint256(_in));
    }

    /**
     * Reads the raw bytes of an RLP item.
     * @param _in RLP item to read.
     * @return Raw RLP bytes.
     */
    function readRawBytes(
        RLPItem memory _in
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return _copy(_in);
    }


    /*********************
     * Private Functions *
     *********************/

    /**
     * Decodes the length of an RLP item.
     * @param _in RLP item to decode.
     * @return Offset of the encoded data.
     * @return Length of the encoded data.
     * @return RLP item type (LIST_ITEM or DATA_ITEM).
     */
    function _decodeLength(
        RLPItem memory _in
    )
        private
        pure
        returns (
            uint256,
            uint256,
            RLPItemType
        )
    {
        require(
            _in.length > 0,
            "RLP item cannot be null."
        );

        uint256 ptr = _in.ptr;
        uint256 prefix;
        assembly {
            prefix := byte(0, mload(ptr))
        }

        if (prefix <= 0x7f) {
            // Single byte.

            return (0, 1, RLPItemType.DATA_ITEM);
        } else if (prefix <= 0xb7) {
            // Short string.

            uint256 strLen = prefix - 0x80;
            
            require(
                _in.length > strLen,
                "Invalid RLP short string."
            );

            return (1, strLen, RLPItemType.DATA_ITEM);
        } else if (prefix <= 0xbf) {
            // Long string.
            uint256 lenOfStrLen = prefix - 0xb7;

            require(
                _in.length > lenOfStrLen,
                "Invalid RLP long string length."
            );

            uint256 strLen;
            assembly {
                // Pick out the string length.
                strLen := div(
                    mload(add(ptr, 1)),
                    exp(256, sub(32, lenOfStrLen))
                )
            }

            require(
                _in.length > lenOfStrLen + strLen,
                "Invalid RLP long string."
            );

            return (1 + lenOfStrLen, strLen, RLPItemType.DATA_ITEM);
        } else if (prefix <= 0xf7) {
            // Short list.
            uint256 listLen = prefix - 0xc0;

            require(
                _in.length > listLen,
                "Invalid RLP short list."
            );

            return (1, listLen, RLPItemType.LIST_ITEM);
        } else {
            // Long list.
            uint256 lenOfListLen = prefix - 0xf7;

            require(
                _in.length > lenOfListLen,
                "Invalid RLP long list length."
            );

            uint256 listLen;
            assembly {
                // Pick out the list length.
                listLen := div(
                    mload(add(ptr, 1)),
                    exp(256, sub(32, lenOfListLen))
                )
            }

            require(
                _in.length > lenOfListLen + listLen,
                "Invalid RLP long list."
            );

            return (1 + lenOfListLen, listLen, RLPItemType.LIST_ITEM);
        }
    }

    /**
     * Copies the bytes from a memory location.
     * @param _src Pointer to the location to read from.
     * @param _offset Offset to start reading from.
     * @param _length Number of bytes to read.
     * @return Copied bytes.
     */
    function _copy(
        uint256 _src,
        uint256 _offset,
        uint256 _length
    )
        private
        pure
        returns (
            bytes memory
        )
    {
        bytes memory out = new bytes(_length);
        if (out.length == 0) {
            return out;
        }

        uint256 src = _src + _offset;
        uint256 dest;
        assembly {
            dest := add(out, 32)
        }

        // Copy over as many complete words as we can.
        for (uint256 i = 0; i < _length / 32; i++) {
            assembly {
                mstore(dest, mload(src))
            }

            src += 32;
            dest += 32;
        }

        // Pick out the remaining bytes.
        uint256 mask = 256 ** (32 - (_length % 32)) - 1;
        assembly {
            mstore(
                dest,
                or(
                    and(mload(src), not(mask)),
                    and(mload(dest), mask)
                )
            )
        }

        return out;
    }

    /**
     * Copies an RLP item into bytes.
     * @param _in RLP item to copy.
     * @return Copied bytes.
     */
    function _copy(
        RLPItem memory _in
    )
        private
        pure
        returns (
            bytes memory
        )
    {
        return _copy(_in.ptr, 0, _in.length);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/utils/Lib_BytesUtils.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title Lib_BytesUtils
 */
library Lib_BytesUtils {

    /**********************
     * Internal Functions *
     **********************/

    function slice(
        bytes memory _bytes,
        uint256 _start,
        uint256 _length
    )
        internal
        pure
        returns (bytes memory)
    {
        require(_length + 31 >= _length, "slice_overflow");
        require(_start + _length >= _start, "slice_overflow");
        require(_bytes.length >= _start + _length, "slice_outOfBounds");

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                // Get a location of some free memory and store it in tempBytes as
                // Solidity does for memory variables.
                tempBytes := mload(0x40)

                // The first word of the slice result is potentially a partial
                // word read from the original array. To read it, we calculate
                // the length of that partial word and start copying that many
                // bytes into the array. The first word we copy will start with
                // data we don't care about, but the last `lengthmod` bytes will
                // land at the beginning of the contents of the new array. When
                // we're done copying, we overwrite the full first word with
                // the actual length of the slice.
                let lengthmod := and(_length, 31)

                // The multiplication in the next line is necessary
                // because when slicing multiples of 32 bytes (lengthmod == 0)
                // the following copy loop was copying the origin's length
                // and then ending prematurely not copying everything it should.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    // The multiplication in the next line has the same exact purpose
                    // as the one above.
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }

                mstore(tempBytes, _length)

                //update free-memory pointer
                //allocating the array padded to 32 bytes like the compiler does now
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            //if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)

                //zero out the 32 bytes slice we are about to return
                //we need to do it because Solidity does not garbage collect
                mstore(tempBytes, 0)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function slice(
        bytes memory _bytes,
        uint256 _start
    )
        internal
        pure
        returns (bytes memory)
    {
        if (_bytes.length - _start == 0) {
            return bytes('');
        }

        return slice(_bytes, _start, _bytes.length - _start);
    }

    function toBytes32PadLeft(
        bytes memory _bytes
    )
        internal
        pure
        returns (bytes32)
    {
        bytes32 ret;
        uint256 len = _bytes.length <= 32 ? _bytes.length : 32;
        assembly {
            ret := shr(mul(sub(32, len), 8), mload(add(_bytes, 32)))
        }
        return ret;
    }

    function toBytes32(
        bytes memory _bytes
    )
        internal
        pure
        returns (bytes32)
    {
        if (_bytes.length < 32) {
            bytes32 ret;
            assembly {
                ret := mload(add(_bytes, 32))
            }
            return ret;
        }

        return abi.decode(_bytes,(bytes32)); // will truncate if input length > 32 bytes
    }

    function toUint256(
        bytes memory _bytes
    )
        internal
        pure
        returns (uint256)
    {
        return uint256(toBytes32(_bytes));
    }

    function toUint24(bytes memory _bytes, uint256 _start) internal pure returns (uint24) {
        require(_start + 3 >= _start, "toUint24_overflow");
        require(_bytes.length >= _start + 3 , "toUint24_outOfBounds");
        uint24 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x3), _start))
        }

        return tempUint;
    }

    function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
        require(_start + 1 >= _start, "toUint8_overflow");
        require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function toAddress(bytes memory _bytes, uint256 _start) internal pure returns (address) {
        require(_start + 20 >= _start, "toAddress_overflow");
        require(_bytes.length >= _start + 20, "toAddress_outOfBounds");
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function toNibbles(
        bytes memory _bytes
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory nibbles = new bytes(_bytes.length * 2);

        for (uint256 i = 0; i < _bytes.length; i++) {
            nibbles[i * 2] = _bytes[i] >> 4;
            nibbles[i * 2 + 1] = bytes1(uint8(_bytes[i]) % 16);
        }

        return nibbles;
    }

    function fromNibbles(
        bytes memory _bytes
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory ret = new bytes(_bytes.length / 2);

        for (uint256 i = 0; i < ret.length; i++) {
            ret[i] = (_bytes[i * 2] << 4) | (_bytes[i * 2 + 1]);
        }

        return ret;
    }

    function equal(
        bytes memory _bytes,
        bytes memory _other
    )
        internal
        pure
        returns (bool)
    {
        return keccak256(_bytes) == keccak256(_other);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/rlp/Lib_RLPWriter.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */

/**
 * @title Lib_RLPWriter
 * @author Bakaoh (with modifications)
 */
library Lib_RLPWriter {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * RLP encodes a byte string.
     * @param _in The byte string to encode.
     * @return _out The RLP encoded string in bytes.
     */
    function writeBytes(
        bytes memory _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        bytes memory encoded;

        if (_in.length == 1 && uint8(_in[0]) < 128) {
            encoded = _in;
        } else {
            encoded = abi.encodePacked(_writeLength(_in.length, 128), _in);
        }

        return encoded;
    }

    /**
     * RLP encodes a list of RLP encoded byte byte strings.
     * @param _in The list of RLP encoded byte strings.
     * @return _out The RLP encoded list of items in bytes.
     */
    function writeList(
        bytes[] memory _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        bytes memory list = _flatten(_in);
        return abi.encodePacked(_writeLength(list.length, 192), list);
    }

    /**
     * RLP encodes a string.
     * @param _in The string to encode.
     * @return _out The RLP encoded string in bytes.
     */
    function writeString(
        string memory _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        return writeBytes(bytes(_in));
    }

    /**
     * RLP encodes an address.
     * @param _in The address to encode.
     * @return _out The RLP encoded address in bytes.
     */
    function writeAddress(
        address _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        return writeBytes(abi.encodePacked(_in));
    }

    /**
     * RLP encodes a bytes32 value.
     * @param _in The bytes32 to encode.
     * @return _out The RLP encoded bytes32 in bytes.
     */
    function writeBytes32(
        bytes32 _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        return writeBytes(abi.encodePacked(_in));
    }

    /**
     * RLP encodes a uint.
     * @param _in The uint256 to encode.
     * @return _out The RLP encoded uint256 in bytes.
     */
    function writeUint(
        uint256 _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        return writeBytes(_toBinary(_in));
    }

    /**
     * RLP encodes a bool.
     * @param _in The bool to encode.
     * @return _out The RLP encoded bool in bytes.
     */
    function writeBool(
        bool _in
    )
        internal
        pure
        returns (
            bytes memory _out
        )
    {
        bytes memory encoded = new bytes(1);
        encoded[0] = (_in ? bytes1(0x01) : bytes1(0x80));
        return encoded;
    }


    /*********************
     * Private Functions *
     *********************/

    /**
     * Encode the first byte, followed by the `len` in binary form if `length` is more than 55.
     * @param _len The length of the string or the payload.
     * @param _offset 128 if item is string, 192 if item is list.
     * @return _encoded RLP encoded bytes.
     */
    function _writeLength(
        uint256 _len,
        uint256 _offset
    )
        private
        pure
        returns (
            bytes memory _encoded
        )
    {
        bytes memory encoded;

        if (_len < 56) {
            encoded = new bytes(1);
            encoded[0] = byte(uint8(_len) + uint8(_offset));
        } else {
            uint256 lenLen;
            uint256 i = 1;
            while (_len / i != 0) {
                lenLen++;
                i *= 256;
            }

            encoded = new bytes(lenLen + 1);
            encoded[0] = byte(uint8(lenLen) + uint8(_offset) + 55);
            for(i = 1; i <= lenLen; i++) {
                encoded[i] = byte(uint8((_len / (256**(lenLen-i))) % 256));
            }
        }

        return encoded;
    }

    /**
     * Encode integer in big endian binary form with no leading zeroes.
     * @notice TODO: This should be optimized with assembly to save gas costs.
     * @param _x The integer to encode.
     * @return _binary RLP encoded bytes.
     */
    function _toBinary(
        uint256 _x
    )
        private
        pure
        returns (
            bytes memory _binary
        )
    {
        bytes memory b = abi.encodePacked(_x);

        uint256 i = 0;
        for (; i < 32; i++) {
            if (b[i] != 0) {
                break;
            }
        }

        bytes memory res = new bytes(32 - i);
        for (uint256 j = 0; j < res.length; j++) {
            res[j] = b[i++];
        }

        return res;
    }

    /**
     * Copies a piece of memory to another location.
     * @notice From: https://github.com/Arachnid/solidity-stringutils/blob/master/src/strings.sol.
     * @param _dest Destination location.
     * @param _src Source location.
     * @param _len Length of memory to copy.
     */
    function _memcpy(
        uint256 _dest,
        uint256 _src,
        uint256 _len
    )
        private
        pure
    {
        uint256 dest = _dest;
        uint256 src = _src;
        uint256 len = _len;

        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        uint256 mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    /**
     * Flattens a list of byte strings into one byte string.
     * @notice From: https://github.com/sammayo/solidity-rlp-encoder/blob/master/RLPEncode.sol.
     * @param _list List of byte strings to flatten.
     * @return _flattened The flattened byte string.
     */
    function _flatten(
        bytes[] memory _list
    )
        private
        pure
        returns (
            bytes memory _flattened
        )
    {
        if (_list.length == 0) {
            return new bytes(0);
        }

        uint256 len;
        uint256 i = 0;
        for (; i < _list.length; i++) {
            len += _list[i].length;
        }

        bytes memory flattened = new bytes(len);
        uint256 flattenedPtr;
        assembly { flattenedPtr := add(flattened, 0x20) }

        for(i = 0; i < _list.length; i++) {
            bytes memory item = _list[i];

            uint256 listPtr;
            assembly { listPtr := add(item, 0x20)}

            _memcpy(flattenedPtr, listPtr, item.length);
            flattenedPtr += _list[i].length;
        }

        return flattened;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/utils/Lib_Bytes32Utils.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title Lib_Byte32Utils
 */
library Lib_Bytes32Utils {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Converts a bytes32 value to a boolean. Anything non-zero will be converted to "true."
     * @param _in Input bytes32 value.
     * @return Bytes32 as a boolean.
     */
    function toBool(
        bytes32 _in
    )
        internal
        pure
        returns (
            bool
        )
    {
        return _in != 0;
    }

    /**
     * Converts a boolean to a bytes32 value.
     * @param _in Input boolean value.
     * @return Boolean as a bytes32.
     */
    function fromBool(
        bool _in
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return bytes32(uint256(_in ? 1 : 0));
    }

    /**
     * Converts a bytes32 value to an address. Takes the *last* 20 bytes.
     * @param _in Input bytes32 value.
     * @return Bytes32 as an address.
     */
    function toAddress(
        bytes32 _in
    )
        internal
        pure
        returns (
            address
        )
    {
        return address(uint160(uint256(_in)));
    }

    /**
     * Converts an address to a bytes32.
     * @param _in Input address value.
     * @return Address as a bytes32.
     */
    function fromAddress(
        address _in
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return bytes32(uint256(_in));
    }

    /**
     * Removes the leading zeros from a bytes32 value and returns a new (smaller) bytes value.
     * @param _in Input bytes32 value.
     * @return Bytes32 without any leading zeros.
     */
    function removeLeadingZeros(
        bytes32 _in
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        bytes memory out;

        assembly {
            // Figure out how many leading zero bytes to remove.
            let shift := 0
            for { let i := 0 } and(lt(i, 32), eq(byte(i, _in), 0)) { i := add(i, 1) } {
                shift := add(shift, 1)
            }

            // Reserve some space for our output and fix the free memory pointer.
            out := mload(0x40)
            mstore(0x40, add(out, 0x40))

            // Shift the value and store it into the output bytes.
            mstore(add(out, 0x20), shl(mul(shift, 8), _in))

            // Store the new size (with leading zero bytes removed) in the output byte size.
            mstore(out, sub(32, shift))
        }

        return out;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/utils/Lib_ErrorUtils.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/**
 * @title Lib_ErrorUtils
 */
library Lib_ErrorUtils {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Encodes an error string into raw solidity-style revert data.
     * (i.e. ascii bytes, prefixed with bytes4(keccak("Error(string))"))
     * Ref: https://docs.soliditylang.org/en/v0.8.2/control-structures.html?highlight=Error(string)#panic-via-assert-and-error-via-require
     * @param _reason Reason for the reversion.
     * @return Standard solidity revert data for the given reason.
     */
    function encodeRevertString(
        string memory _reason
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodeWithSignature(
            "Error(string)",
            _reason
        );
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/wrappers/Lib_SafeExecutionManagerWrapper.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */

/**
 * @title Lib_SafeExecutionManagerWrapper
 * @dev The Safe Execution Manager Wrapper provides functions which facilitate writing OVM safe 
 * code using the standard solidity compiler, by routing all its operations through the Execution 
 * Manager.
 * 
 * Compiler used: solc
 * Runtime target: OVM
 */
library Lib_SafeExecutionManagerWrapper {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Performs a safe ovmCALL.
     * @param _gasLimit Gas limit for the call.
     * @param _target Address to call.
     * @param _calldata Data to send to the call.
     * @return _success Whether or not the call reverted.
     * @return _returndata Data returned by the call.
     */
    function safeCALL(
        uint256 _gasLimit,
        address _target,
        bytes memory _calldata
    )
        internal
        returns (
            bool _success,
            bytes memory _returndata
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCALL(uint256,address,bytes)",
                _gasLimit,
                _target,
                _calldata
            )
        );

        return abi.decode(returndata, (bool, bytes));
    }

    /**
     * Performs a safe ovmDELEGATECALL.
     * @param _gasLimit Gas limit for the call.
     * @param _target Address to call.
     * @param _calldata Data to send to the call.
     * @return _success Whether or not the call reverted.
     * @return _returndata Data returned by the call.
     */
    function safeDELEGATECALL(
        uint256 _gasLimit,
        address _target,
        bytes memory _calldata
    )
        internal
        returns (
            bool _success,
            bytes memory _returndata
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmDELEGATECALL(uint256,address,bytes)",
                _gasLimit,
                _target,
                _calldata
            )
        );

        return abi.decode(returndata, (bool, bytes));
    }

    /**
     * Performs a safe ovmCREATE call.
     * @param _gasLimit Gas limit for the creation.
     * @param _bytecode Code for the new contract.
     * @return _contract Address of the created contract.
     */
    function safeCREATE(
        uint256 _gasLimit,
        bytes memory _bytecode
    )
        internal
        returns (
            address,
            bytes memory
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            _gasLimit,
            abi.encodeWithSignature(
                "ovmCREATE(bytes)",
                _bytecode
            )
        );

        return abi.decode(returndata, (address, bytes));
    }

    /**
     * Performs a safe ovmEXTCODESIZE call.
     * @param _contract Address of the contract to query the size of.
     * @return _EXTCODESIZE Size of the requested contract in bytes.
     */
    function safeEXTCODESIZE(
        address _contract
    )
        internal
        returns (
            uint256 _EXTCODESIZE
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmEXTCODESIZE(address)",
                _contract
            )
        );

        return abi.decode(returndata, (uint256));
    }

    /**
     * Performs a safe ovmCHAINID call.
     * @return _CHAINID Result of calling ovmCHAINID.
     */
    function safeCHAINID()
        internal
        returns (
            uint256 _CHAINID
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCHAINID()"
            )
        );

        return abi.decode(returndata, (uint256));
    }

    /**
     * Performs a safe ovmCALLER call.
     * @return _CALLER Result of calling ovmCALLER.
     */
    function safeCALLER()
        internal
        returns (
            address _CALLER
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCALLER()"
            )
        );

        return abi.decode(returndata, (address));
    }

    /**
     * Performs a safe ovmADDRESS call.
     * @return _ADDRESS Result of calling ovmADDRESS.
     */
    function safeADDRESS()
        internal
        returns (
            address _ADDRESS
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmADDRESS()"
            )
        );

        return abi.decode(returndata, (address));
    }

    /**
     * Performs a safe ovmGETNONCE call.
     * @return _nonce Result of calling ovmGETNONCE.
     */
    function safeGETNONCE()
        internal
        returns (
            uint64 _nonce
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmGETNONCE()"
            )
        );

        return abi.decode(returndata, (uint64));
    }

    /**
     * Performs a safe ovmSETNONCE call.
     * @param _nonce New account nonce.
     */
    function safeSETNONCE(
        uint64 _nonce
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmSETNONCE(uint64)",
                _nonce
            )
        );
    }

    /**
     * Performs a safe ovmCREATEEOA call.
     * @param _messageHash Message hash which was signed by EOA
     * @param _v v value of signature (0 or 1)
     * @param _r r value of signature
     * @param _s s value of signature
     */
    function safeCREATEEOA(
        bytes32 _messageHash,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmCREATEEOA(bytes32,uint8,bytes32,bytes32)",
                _messageHash,
                _v,
                _r,
                _s
            )
        );
    }

    /**
     * Performs a safe REVERT.
     * @param _reason String revert reason to pass along with the REVERT.
     */
    function safeREVERT(
        string memory _reason
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmREVERT(bytes)",
                Lib_ErrorUtils.encodeRevertString(
                    _reason
                )
            )
        );
    }

    /**
     * Performs a safe "require".
     * @param _condition Boolean condition that must be true or will revert.
     * @param _reason String revert reason to pass along with the REVERT.
     */
    function safeREQUIRE(
        bool _condition,
        string memory _reason
    )
        internal
    {
        if (!_condition) {
            safeREVERT(
                _reason
            );
        }
    }

    /**
     * Performs a safe ovmSLOAD call.
     */
    function safeSLOAD(
        bytes32 _key
    )
        internal
        returns (
            bytes32
        )
    {
        bytes memory returndata = _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmSLOAD(bytes32)",
                _key
            )
        );

        return abi.decode(returndata, (bytes32));
    }

    /**
     * Performs a safe ovmSSTORE call.
     */
    function safeSSTORE(
        bytes32 _key,
        bytes32 _value
    )
        internal
    {
        _safeExecutionManagerInteraction(
            abi.encodeWithSignature(
                "ovmSSTORE(bytes32,bytes32)",
                _key,
                _value
            )
        );
    }

    /*********************
     * Private Functions *
     *********************/

    /**
     * Performs an ovm interaction and the necessary safety checks.
     * @param _gasLimit Gas limit for the interaction.
     * @param _calldata Data to send to the OVM_ExecutionManager (encoded with sighash).
     * @return _returndata Data sent back by the OVM_ExecutionManager.
     */
    function _safeExecutionManagerInteraction(
        uint256 _gasLimit,
        bytes memory _calldata
    )
        private
        returns (
            bytes memory _returndata
        )
    {
        address ovmExecutionManager = msg.sender;
        (
            bool success,
            bytes memory returndata
        ) = ovmExecutionManager.call{gas: _gasLimit}(_calldata);

        if (success == false) {
            assembly {
                revert(add(returndata, 0x20), mload(returndata))
            }
        } else if (returndata.length == 1) {
            assembly {
                return(0, 1)
            }
        } else {
            return returndata;
        }
    }

    function _safeExecutionManagerInteraction(
        bytes memory _calldata
    )
        private
        returns (
            bytes memory _returndata
        )
    {
        return _safeExecutionManagerInteraction(
            gasleft(),
            _calldata
        );
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/codec/Lib_OVMCodec.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */





/**
 * @title Lib_OVMCodec
 */
library Lib_OVMCodec {

    /*********
     * Enums *
     *********/

    enum QueueOrigin {
        SEQUENCER_QUEUE,
        L1TOL2_QUEUE
    }


    /***********
     * Structs *
     ***********/

    struct Account {
        uint64 nonce;
        uint256 balance;
        bytes32 storageRoot;
        bytes32 codeHash;
        address ethAddress;
        bool isFresh;
    }

    struct EVMAccount {
        uint64 nonce;
        uint256 balance;
        bytes32 storageRoot;
        bytes32 codeHash;
    }

    struct ChainBatchHeader {
        uint256 batchIndex;
        bytes32 batchRoot;
        uint256 batchSize;
        uint256 prevTotalElements;
        bytes extraData;
    }

    struct ChainInclusionProof {
        uint256 index;
        bytes32[] siblings;
    }

    struct Transaction {
        uint256 timestamp;
        uint256 blockNumber;
        QueueOrigin l1QueueOrigin;
        address l1TxOrigin;
        address entrypoint;
        uint256 gasLimit;
        bytes data;
    }

    struct TransactionChainElement {
        bool isSequenced;
        uint256 queueIndex;  // QUEUED TX ONLY
        uint256 timestamp;   // SEQUENCER TX ONLY
        uint256 blockNumber; // SEQUENCER TX ONLY
        bytes txData;        // SEQUENCER TX ONLY
    }

    struct QueueElement {
        bytes32 transactionHash;
        uint40 timestamp;
        uint40 blockNumber;
    }

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Encodes a standard OVM transaction.
     * @param _transaction OVM transaction to encode.
     * @return Encoded transaction bytes.
     */
    function encodeTransaction(
        Transaction memory _transaction
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodePacked(
            _transaction.timestamp,
            _transaction.blockNumber,
            _transaction.l1QueueOrigin,
            _transaction.l1TxOrigin,
            _transaction.entrypoint,
            _transaction.gasLimit,
            _transaction.data
        );
    }

    /**
     * Hashes a standard OVM transaction.
     * @param _transaction OVM transaction to encode.
     * @return Hashed transaction
     */
    function hashTransaction(
        Transaction memory _transaction
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return keccak256(encodeTransaction(_transaction));
    }

    /**
     * Converts an OVM account to an EVM account.
     * @param _in OVM account to convert.
     * @return Converted EVM account.
     */
    function toEVMAccount(
        Account memory _in
    )
        internal
        pure
        returns (
            EVMAccount memory
        )
    {
        return EVMAccount({
            nonce: _in.nonce,
            balance: _in.balance,
            storageRoot: _in.storageRoot,
            codeHash: _in.codeHash
        });
    }

    /**
     * @notice RLP-encodes an account state struct.
     * @param _account Account state struct.
     * @return RLP-encoded account state.
     */
    function encodeEVMAccount(
        EVMAccount memory _account
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        bytes[] memory raw = new bytes[](4);

        // Unfortunately we can't create this array outright because
        // Lib_RLPWriter.writeList will reject fixed-size arrays. Assigning
        // index-by-index circumvents this issue.
        raw[0] = Lib_RLPWriter.writeBytes(
            Lib_Bytes32Utils.removeLeadingZeros(
                bytes32(uint256(_account.nonce))
            )
        );
        raw[1] = Lib_RLPWriter.writeBytes(
            Lib_Bytes32Utils.removeLeadingZeros(
                bytes32(_account.balance)
            )
        );
        raw[2] = Lib_RLPWriter.writeBytes(abi.encodePacked(_account.storageRoot));
        raw[3] = Lib_RLPWriter.writeBytes(abi.encodePacked(_account.codeHash));

        return Lib_RLPWriter.writeList(raw);
    }

    /**
     * @notice Decodes an RLP-encoded account state into a useful struct.
     * @param _encoded RLP-encoded account state.
     * @return Account state struct.
     */
    function decodeEVMAccount(
        bytes memory _encoded
    )
        internal
        pure
        returns (
            EVMAccount memory
        )
    {
        Lib_RLPReader.RLPItem[] memory accountState = Lib_RLPReader.readList(_encoded);

        return EVMAccount({
            nonce: uint64(Lib_RLPReader.readUint256(accountState[0])),
            balance: Lib_RLPReader.readUint256(accountState[1]),
            storageRoot: Lib_RLPReader.readBytes32(accountState[2]),
            codeHash: Lib_RLPReader.readBytes32(accountState[3])
        });
    }

    /**
     * Calculates a hash for a given batch header.
     * @param _batchHeader Header to hash.
     * @return Hash of the header.
     */
    function hashBatchHeader(
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader
    )
        internal
        pure
        returns (
            bytes32
        )
    {
        return keccak256(
            abi.encode(
                _batchHeader.batchRoot,
                _batchHeader.batchSize,
                _batchHeader.prevTotalElements,
                _batchHeader.extraData
            )
        );
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/resolver/Lib_Ownable.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title Ownable
 * @dev Adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
 */
abstract contract Ownable {

    /*************
     * Variables *
     *************/

    address public owner;


    /**********
     * Events *
     **********/

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );


    /***************
     * Constructor *
     ***************/

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }


    /**********************
     * Function Modifiers *
     **********************/

    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Ownable: caller is not the owner"
        );
        _;
    }


    /********************
     * Public Functions *
     ********************/

    function renounceOwnership()
        public
        virtual
        onlyOwner
    {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }

    function transferOwnership(address _newOwner)
        public
        virtual
        onlyOwner
    {
        require(
            _newOwner != address(0),
            "Ownable: new owner cannot be the zero address"
        );

        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/resolver/Lib_AddressManager.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Contract Imports */

/**
 * @title Lib_AddressManager
 */
contract Lib_AddressManager is Ownable {

    /**********
     * Events *
     **********/

    event AddressSet(
        string _name,
        address _newAddress
    );

    /*******************************************
     * Contract Variables: Internal Accounting *
     *******************************************/

    mapping (bytes32 => address) private addresses;


    /********************
     * Public Functions *
     ********************/

    function setAddress(
        string memory _name,
        address _address
    )
        public
        onlyOwner
    {
        emit AddressSet(_name, _address);
        addresses[_getNameHash(_name)] = _address;
    }

    function getAddress(
        string memory _name
    )
        public
        view
        returns (address)
    {
        return addresses[_getNameHash(_name)];
    }


    /**********************
     * Internal Functions *
     **********************/

    function _getNameHash(
        string memory _name
    )
        internal
        pure
        returns (
            bytes32 _hash
        )
    {
        return keccak256(abi.encodePacked(_name));
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/resolver/Lib_AddressResolver.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */

/**
 * @title Lib_AddressResolver
 */
abstract contract Lib_AddressResolver {

    /*******************************************
     * Contract Variables: Contract References *
     *******************************************/

    Lib_AddressManager internal libAddressManager;


    /***************
     * Constructor *
     ***************/

    /**
     * @param _libAddressManager Address of the Lib_AddressManager.
     */
    constructor(
        address _libAddressManager
    )  {
        libAddressManager = Lib_AddressManager(_libAddressManager);
    }


    /********************
     * Public Functions *
     ********************/

    function resolve(
        string memory _name
    )
        public
        view
        returns (
            address _contract
        )
    {
        return libAddressManager.getAddress(_name);
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/trie/Lib_MerkleTrie.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/* Library Imports */



/**
 * @title Lib_MerkleTrie
 */
library Lib_MerkleTrie {

    /*******************
     * Data Structures *
     *******************/

    enum NodeType {
        BranchNode,
        ExtensionNode,
        LeafNode
    }

    struct TrieNode {
        bytes encoded;
        Lib_RLPReader.RLPItem[] decoded;
    }


    /**********************
     * Contract Constants *
     **********************/

    // TREE_RADIX determines the number of elements per branch node.
    uint256 constant TREE_RADIX = 16;
    // Branch nodes have TREE_RADIX elements plus an additional `value` slot.
    uint256 constant BRANCH_NODE_LENGTH = TREE_RADIX + 1;
    // Leaf nodes and extension nodes always have two elements, a `path` and a `value`.
    uint256 constant LEAF_OR_EXTENSION_NODE_LENGTH = 2;

    // Prefixes are prepended to the `path` within a leaf or extension node and
    // allow us to differentiate between the two node types. `ODD` or `EVEN` is
    // determined by the number of nibbles within the unprefixed `path`. If the
    // number of nibbles if even, we need to insert an extra padding nibble so
    // the resulting prefixed `path` has an even number of nibbles.
    uint8 constant PREFIX_EXTENSION_EVEN = 0;
    uint8 constant PREFIX_EXTENSION_ODD = 1;
    uint8 constant PREFIX_LEAF_EVEN = 2;
    uint8 constant PREFIX_LEAF_ODD = 3;

    // Just a utility constant. RLP represents `NULL` as 0x80.
    bytes1 constant RLP_NULL = bytes1(0x80);
    bytes constant RLP_NULL_BYTES = hex'80';
    bytes32 constant internal KECCAK256_RLP_NULL_BYTES = keccak256(RLP_NULL_BYTES);


    /**********************
     * Internal Functions *
     **********************/

    /**
     * @notice Verifies a proof that a given key/value pair is present in the
     * Merkle trie.
     * @param _key Key of the node to search for, as a hex string.
     * @param _value Value of the node to search for, as a hex string.
     * @param _proof Merkle trie inclusion proof for the desired node. Unlike
     * traditional Merkle trees, this proof is executed top-down and consists
     * of a list of RLP-encoded nodes that make a path down to the target node.
     * @param _root Known root of the Merkle trie. Used to verify that the
     * included proof is correctly constructed.
     * @return _verified `true` if the k/v pair exists in the trie, `false` otherwise.
     */
    function verifyInclusionProof(
        bytes memory _key,
        bytes memory _value,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bool _verified
        )
    {
        (
            bool exists,
            bytes memory value
        ) = get(_key, _proof, _root);

        return (
            exists && Lib_BytesUtils.equal(_value, value)
        );
    }

    /**
     * @notice Verifies a proof that a given key is *not* present in
     * the Merkle trie.
     * @param _key Key of the node to search for, as a hex string.
     * @param _proof Merkle trie inclusion proof for the node *nearest* the
     * target node.
     * @param _root Known root of the Merkle trie. Used to verify that the
     * included proof is correctly constructed.
     * @return _verified `true` if the key is absent in the trie, `false` otherwise.
     */
    function verifyExclusionProof(
        bytes memory _key,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bool _verified
        )
    {
        (
            bool exists,
        ) = get(_key, _proof, _root);

        return exists == false;
    }

    /**
     * @notice Updates a Merkle trie and returns a new root hash.
     * @param _key Key of the node to update, as a hex string.
     * @param _value Value of the node to update, as a hex string.
     * @param _proof Merkle trie inclusion proof for the node *nearest* the
     * target node. If the key exists, we can simply update the value.
     * Otherwise, we need to modify the trie to handle the new k/v pair.
     * @param _root Known root of the Merkle trie. Used to verify that the
     * included proof is correctly constructed.
     * @return _updatedRoot Root hash of the newly constructed trie.
     */
    function update(
        bytes memory _key,
        bytes memory _value,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bytes32 _updatedRoot
        )
    {
        // Special case when inserting the very first node.
        if (_root == KECCAK256_RLP_NULL_BYTES) {
            return getSingleNodeRootHash(_key, _value);
        }

        TrieNode[] memory proof = _parseProof(_proof);
        (uint256 pathLength, bytes memory keyRemainder, ) = _walkNodePath(proof, _key, _root);
        TrieNode[] memory newPath = _getNewPath(proof, pathLength, keyRemainder, _value);

        return _getUpdatedTrieRoot(newPath, _key);
    }

    /**
     * @notice Retrieves the value associated with a given key.
     * @param _key Key to search for, as hex bytes.
     * @param _proof Merkle trie inclusion proof for the key.
     * @param _root Known root of the Merkle trie.
     * @return _exists Whether or not the key exists.
     * @return _value Value of the key if it exists.
     */
    function get(
        bytes memory _key,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bool _exists,
            bytes memory _value
        )
    {
        TrieNode[] memory proof = _parseProof(_proof);
        (uint256 pathLength, bytes memory keyRemainder, bool isFinalNode) = _walkNodePath(proof, _key, _root);

        bool exists = keyRemainder.length == 0;

        require(
            exists || isFinalNode,
            "Provided proof is invalid."
        );

        bytes memory value = exists ? _getNodeValue(proof[pathLength - 1]) : bytes('');

        return (
            exists,
            value
        );
    }

    /**
     * Computes the root hash for a trie with a single node.
     * @param _key Key for the single node.
     * @param _value Value for the single node.
     * @return _updatedRoot Hash of the trie.
     */
    function getSingleNodeRootHash(
        bytes memory _key,
        bytes memory _value
    )
        internal
        pure
        returns (
            bytes32 _updatedRoot
        )
    {
        return keccak256(_makeLeafNode(
            Lib_BytesUtils.toNibbles(_key),
            _value
        ).encoded);
    }


    /*********************
     * Private Functions *
     *********************/

    /**
     * @notice Walks through a proof using a provided key.
     * @param _proof Inclusion proof to walk through.
     * @param _key Key to use for the walk.
     * @param _root Known root of the trie.
     * @return _pathLength Length of the final path
     * @return _keyRemainder Portion of the key remaining after the walk.
     * @return _isFinalNode Whether or not we've hit a dead end.
     */
    function _walkNodePath(
        TrieNode[] memory _proof,
        bytes memory _key,
        bytes32 _root
    )
        private
        pure
        returns (
            uint256 _pathLength,
            bytes memory _keyRemainder,
            bool _isFinalNode
        )
    {
        uint256 pathLength = 0;
        bytes memory key = Lib_BytesUtils.toNibbles(_key);

        bytes32 currentNodeID = _root;
        uint256 currentKeyIndex = 0;
        uint256 currentKeyIncrement = 0;
        TrieNode memory currentNode;

        // Proof is top-down, so we start at the first element (root).
        for (uint256 i = 0; i < _proof.length; i++) {
            currentNode = _proof[i];
            currentKeyIndex += currentKeyIncrement;

            // Keep track of the proof elements we actually need.
            // It's expensive to resize arrays, so this simply reduces gas costs.
            pathLength += 1;

            if (currentKeyIndex == 0) {
                // First proof element is always the root node.
                require(
                    keccak256(currentNode.encoded) == currentNodeID,
                    "Invalid root hash"
                );
            } else if (currentNode.encoded.length >= 32) {
                // Nodes 32 bytes or larger are hashed inside branch nodes.
                require(
                    keccak256(currentNode.encoded) == currentNodeID,
                    "Invalid large internal hash"
                );
            } else {
                // Nodes smaller than 31 bytes aren't hashed.
                require(
                    Lib_BytesUtils.toBytes32(currentNode.encoded) == currentNodeID,
                    "Invalid internal node hash"
                );
            }

            if (currentNode.decoded.length == BRANCH_NODE_LENGTH) {
                if (currentKeyIndex == key.length) {
                    // We've hit the end of the key, meaning the value should be within this branch node.
                    break;
                } else {
                    // We're not at the end of the key yet.
                    // Figure out what the next node ID should be and continue.
                    uint8 branchKey = uint8(key[currentKeyIndex]);
                    Lib_RLPReader.RLPItem memory nextNode = currentNode.decoded[branchKey];
                    currentNodeID = _getNodeID(nextNode);
                    currentKeyIncrement = 1;
                    continue;
                }
            } else if (currentNode.decoded.length == LEAF_OR_EXTENSION_NODE_LENGTH) {
                bytes memory path = _getNodePath(currentNode);
                uint8 prefix = uint8(path[0]);
                uint8 offset = 2 - prefix % 2;
                bytes memory pathRemainder = Lib_BytesUtils.slice(path, offset);
                bytes memory keyRemainder = Lib_BytesUtils.slice(key, currentKeyIndex);
                uint256 sharedNibbleLength = _getSharedNibbleLength(pathRemainder, keyRemainder);

                if (prefix == PREFIX_LEAF_EVEN || prefix == PREFIX_LEAF_ODD) {
                    if (
                        pathRemainder.length == sharedNibbleLength &&
                        keyRemainder.length == sharedNibbleLength
                    ) {
                        // The key within this leaf matches our key exactly.
                        // Increment the key index to reflect that we have no remainder.
                        currentKeyIndex += sharedNibbleLength;
                    }

                    // We've hit a leaf node, so our next node should be NULL.
                    currentNodeID = bytes32(RLP_NULL);
                    break;
                } else if (prefix == PREFIX_EXTENSION_EVEN || prefix == PREFIX_EXTENSION_ODD) {
                    if (sharedNibbleLength == 0) {
                        // Our extension node doesn't share any part of our key.
                        // We've hit the end of this path, updates will need to modify this extension.
                        currentNodeID = bytes32(RLP_NULL);
                        break;
                    } else {
                        // Our extension shares some nibbles.
                        // Carry on to the next node.
                        currentNodeID = _getNodeID(currentNode.decoded[1]);
                        currentKeyIncrement = sharedNibbleLength;
                        continue;
                    }
                } else {
                    revert("Received a node with an unknown prefix");
                }
            } else {
                revert("Received an unparseable node.");
            }
        }

        // If our node ID is NULL, then we're at a dead end.
        bool isFinalNode = currentNodeID == bytes32(RLP_NULL);
        return (pathLength, Lib_BytesUtils.slice(key, currentKeyIndex), isFinalNode);
    }

    /**
     * @notice Creates new nodes to support a k/v pair insertion into a given
     * Merkle trie path.
     * @param _path Path to the node nearest the k/v pair.
     * @param _pathLength Length of the path. Necessary because the provided
     * path may include additional nodes (e.g., it comes directly from a proof)
     * and we can't resize in-memory arrays without costly duplication.
     * @param _keyRemainder Portion of the initial key that must be inserted
     * into the trie.
     * @param _value Value to insert at the given key.
     * @return _newPath A new path with the inserted k/v pair and extra supporting nodes.
     */
    function _getNewPath(
        TrieNode[] memory _path,
        uint256 _pathLength,
        bytes memory _keyRemainder,
        bytes memory _value
    )
        private
        pure
        returns (
            TrieNode[] memory _newPath
        )
    {
        bytes memory keyRemainder = _keyRemainder;

        // Most of our logic depends on the status of the last node in the path.
        TrieNode memory lastNode = _path[_pathLength - 1];
        NodeType lastNodeType = _getNodeType(lastNode);

        // Create an array for newly created nodes.
        // We need up to three new nodes, depending on the contents of the last node.
        // Since array resizing is expensive, we'll keep track of the size manually.
        // We're using an explicit `totalNewNodes += 1` after insertions for clarity.
        TrieNode[] memory newNodes = new TrieNode[](3);
        uint256 totalNewNodes = 0;

        if (keyRemainder.length == 0 && lastNodeType == NodeType.LeafNode) {
            // We've found a leaf node with the given key.
            // Simply need to update the value of the node to match.
            newNodes[totalNewNodes] = _makeLeafNode(_getNodeKey(lastNode), _value);
            totalNewNodes += 1;
        } else if (lastNodeType == NodeType.BranchNode) {
            if (keyRemainder.length == 0) {
                // We've found a branch node with the given key.
                // Simply need to update the value of the node to match.
                newNodes[totalNewNodes] = _editBranchValue(lastNode, _value);
                totalNewNodes += 1;
            } else {
                // We've found a branch node, but it doesn't contain our key.
                // Reinsert the old branch for now.
                newNodes[totalNewNodes] = lastNode;
                totalNewNodes += 1;
                // Create a new leaf node, slicing our remainder since the first byte points
                // to our branch node.
                newNodes[totalNewNodes] = _makeLeafNode(Lib_BytesUtils.slice(keyRemainder, 1), _value);
                totalNewNodes += 1;
            }
        } else {
            // Our last node is either an extension node or a leaf node with a different key.
            bytes memory lastNodeKey = _getNodeKey(lastNode);
            uint256 sharedNibbleLength = _getSharedNibbleLength(lastNodeKey, keyRemainder);

            if (sharedNibbleLength != 0) {
                // We've got some shared nibbles between the last node and our key remainder.
                // We'll need to insert an extension node that covers these shared nibbles.
                bytes memory nextNodeKey = Lib_BytesUtils.slice(lastNodeKey, 0, sharedNibbleLength);
                newNodes[totalNewNodes] = _makeExtensionNode(nextNodeKey, _getNodeHash(_value));
                totalNewNodes += 1;

                // Cut down the keys since we've just covered these shared nibbles.
                lastNodeKey = Lib_BytesUtils.slice(lastNodeKey, sharedNibbleLength);
                keyRemainder = Lib_BytesUtils.slice(keyRemainder, sharedNibbleLength);
            }

            // Create an empty branch to fill in.
            TrieNode memory newBranch = _makeEmptyBranchNode();

            if (lastNodeKey.length == 0) {
                // Key remainder was larger than the key for our last node.
                // The value within our last node is therefore going to be shifted into
                // a branch value slot.
                newBranch = _editBranchValue(newBranch, _getNodeValue(lastNode));
            } else {
                // Last node key was larger than the key remainder.
                // We're going to modify some index of our branch.
                uint8 branchKey = uint8(lastNodeKey[0]);
                // Move on to the next nibble.
                lastNodeKey = Lib_BytesUtils.slice(lastNodeKey, 1);

                if (lastNodeType == NodeType.LeafNode) {
                    // We're dealing with a leaf node.
                    // We'll modify the key and insert the old leaf node into the branch index.
                    TrieNode memory modifiedLastNode = _makeLeafNode(lastNodeKey, _getNodeValue(lastNode));
                    newBranch = _editBranchIndex(newBranch, branchKey, _getNodeHash(modifiedLastNode.encoded));
                } else if (lastNodeKey.length != 0) {
                    // We're dealing with a shrinking extension node.
                    // We need to modify the node to decrease the size of the key.
                    TrieNode memory modifiedLastNode = _makeExtensionNode(lastNodeKey, _getNodeValue(lastNode));
                    newBranch = _editBranchIndex(newBranch, branchKey, _getNodeHash(modifiedLastNode.encoded));
                } else {
                    // We're dealing with an unnecessary extension node.
                    // We're going to delete the node entirely.
                    // Simply insert its current value into the branch index.
                    newBranch = _editBranchIndex(newBranch, branchKey, _getNodeValue(lastNode));
                }
            }

            if (keyRemainder.length == 0) {
                // We've got nothing left in the key remainder.
                // Simply insert the value into the branch value slot.
                newBranch = _editBranchValue(newBranch, _value);
                // Push the branch into the list of new nodes.
                newNodes[totalNewNodes] = newBranch;
                totalNewNodes += 1;
            } else {
                // We've got some key remainder to work with.
                // We'll be inserting a leaf node into the trie.
                // First, move on to the next nibble.
                keyRemainder = Lib_BytesUtils.slice(keyRemainder, 1);
                // Push the branch into the list of new nodes.
                newNodes[totalNewNodes] = newBranch;
                totalNewNodes += 1;
                // Push a new leaf node for our k/v pair.
                newNodes[totalNewNodes] = _makeLeafNode(keyRemainder, _value);
                totalNewNodes += 1;
            }
        }

        // Finally, join the old path with our newly created nodes.
        // Since we're overwriting the last node in the path, we use `_pathLength - 1`.
        return _joinNodeArrays(_path, _pathLength - 1, newNodes, totalNewNodes);
    }

    /**
     * @notice Computes the trie root from a given path.
     * @param _nodes Path to some k/v pair.
     * @param _key Key for the k/v pair.
     * @return _updatedRoot Root hash for the updated trie.
     */
    function _getUpdatedTrieRoot(
        TrieNode[] memory _nodes,
        bytes memory _key
    )
        private
        pure
        returns (
            bytes32 _updatedRoot
        )
    {
        bytes memory key = Lib_BytesUtils.toNibbles(_key);

        // Some variables to keep track of during iteration.
        TrieNode memory currentNode;
        NodeType currentNodeType;
        bytes memory previousNodeHash;

        // Run through the path backwards to rebuild our root hash.
        for (uint256 i = _nodes.length; i > 0; i--) {
            // Pick out the current node.
            currentNode = _nodes[i - 1];
            currentNodeType = _getNodeType(currentNode);

            if (currentNodeType == NodeType.LeafNode) {
                // Leaf nodes are already correctly encoded.
                // Shift the key over to account for the nodes key.
                bytes memory nodeKey = _getNodeKey(currentNode);
                key = Lib_BytesUtils.slice(key, 0, key.length - nodeKey.length);
            } else if (currentNodeType == NodeType.ExtensionNode) {
                // Shift the key over to account for the nodes key.
                bytes memory nodeKey = _getNodeKey(currentNode);
                key = Lib_BytesUtils.slice(key, 0, key.length - nodeKey.length);

                // If this node is the last element in the path, it'll be correctly encoded
                // and we can skip this part.
                if (previousNodeHash.length > 0) {
                    // Re-encode the node based on the previous node.
                    currentNode = _makeExtensionNode(nodeKey, previousNodeHash);
                }
            } else if (currentNodeType == NodeType.BranchNode) {
                // If this node is the last element in the path, it'll be correctly encoded
                // and we can skip this part.
                if (previousNodeHash.length > 0) {
                    // Re-encode the node based on the previous node.
                    uint8 branchKey = uint8(key[key.length - 1]);
                    key = Lib_BytesUtils.slice(key, 0, key.length - 1);
                    currentNode = _editBranchIndex(currentNode, branchKey, previousNodeHash);
                }
            }

            // Compute the node hash for the next iteration.
            previousNodeHash = _getNodeHash(currentNode.encoded);
        }

        // Current node should be the root at this point.
        // Simply return the hash of its encoding.
        return keccak256(currentNode.encoded);
    }

    /**
     * @notice Parses an RLP-encoded proof into something more useful.
     * @param _proof RLP-encoded proof to parse.
     * @return _parsed Proof parsed into easily accessible structs.
     */
    function _parseProof(
        bytes memory _proof
    )
        private
        pure
        returns (
            TrieNode[] memory _parsed
        )
    {
        Lib_RLPReader.RLPItem[] memory nodes = Lib_RLPReader.readList(_proof);
        TrieNode[] memory proof = new TrieNode[](nodes.length);

        for (uint256 i = 0; i < nodes.length; i++) {
            bytes memory encoded = Lib_RLPReader.readBytes(nodes[i]);
            proof[i] = TrieNode({
                encoded: encoded,
                decoded: Lib_RLPReader.readList(encoded)
            });
        }

        return proof;
    }

    /**
     * @notice Picks out the ID for a node. Node ID is referred to as the
     * "hash" within the specification, but nodes < 32 bytes are not actually
     * hashed.
     * @param _node Node to pull an ID for.
     * @return _nodeID ID for the node, depending on the size of its contents.
     */
    function _getNodeID(
        Lib_RLPReader.RLPItem memory _node
    )
        private
        pure
        returns (
            bytes32 _nodeID
        )
    {
        bytes memory nodeID;

        if (_node.length < 32) {
            // Nodes smaller than 32 bytes are RLP encoded.
            nodeID = Lib_RLPReader.readRawBytes(_node);
        } else {
            // Nodes 32 bytes or larger are hashed.
            nodeID = Lib_RLPReader.readBytes(_node);
        }

        return Lib_BytesUtils.toBytes32(nodeID);
    }

    /**
     * @notice Gets the path for a leaf or extension node.
     * @param _node Node to get a path for.
     * @return _path Node path, converted to an array of nibbles.
     */
    function _getNodePath(
        TrieNode memory _node
    )
        private
        pure
        returns (
            bytes memory _path
        )
    {
        return Lib_BytesUtils.toNibbles(Lib_RLPReader.readBytes(_node.decoded[0]));
    }

    /**
     * @notice Gets the key for a leaf or extension node. Keys are essentially
     * just paths without any prefix.
     * @param _node Node to get a key for.
     * @return _key Node key, converted to an array of nibbles.
     */
    function _getNodeKey(
        TrieNode memory _node
    )
        private
        pure
        returns (
            bytes memory _key
        )
    {
        return _removeHexPrefix(_getNodePath(_node));
    }

    /**
     * @notice Gets the path for a node.
     * @param _node Node to get a value for.
     * @return _value Node value, as hex bytes.
     */
    function _getNodeValue(
        TrieNode memory _node
    )
        private
        pure
        returns (
            bytes memory _value
        )
    {
        return Lib_RLPReader.readBytes(_node.decoded[_node.decoded.length - 1]);
    }

    /**
     * @notice Computes the node hash for an encoded node. Nodes < 32 bytes
     * are not hashed, all others are keccak256 hashed.
     * @param _encoded Encoded node to hash.
     * @return _hash Hash of the encoded node. Simply the input if < 32 bytes.
     */
    function _getNodeHash(
        bytes memory _encoded
    )
        private
        pure
        returns (
            bytes memory _hash
        )
    {
        if (_encoded.length < 32) {
            return _encoded;
        } else {
            return abi.encodePacked(keccak256(_encoded));
        }
    }

    /**
     * @notice Determines the type for a given node.
     * @param _node Node to determine a type for.
     * @return _type Type of the node; BranchNode/ExtensionNode/LeafNode.
     */
    function _getNodeType(
        TrieNode memory _node
    )
        private
        pure
        returns (
            NodeType _type
        )
    {
        if (_node.decoded.length == BRANCH_NODE_LENGTH) {
            return NodeType.BranchNode;
        } else if (_node.decoded.length == LEAF_OR_EXTENSION_NODE_LENGTH) {
            bytes memory path = _getNodePath(_node);
            uint8 prefix = uint8(path[0]);

            if (prefix == PREFIX_LEAF_EVEN || prefix == PREFIX_LEAF_ODD) {
                return NodeType.LeafNode;
            } else if (prefix == PREFIX_EXTENSION_EVEN || prefix == PREFIX_EXTENSION_ODD) {
                return NodeType.ExtensionNode;
            }
        }

        revert("Invalid node type");
    }

    /**
     * @notice Utility; determines the number of nibbles shared between two
     * nibble arrays.
     * @param _a First nibble array.
     * @param _b Second nibble array.
     * @return _shared Number of shared nibbles.
     */
    function _getSharedNibbleLength(
        bytes memory _a,
        bytes memory _b
    )
        private
        pure
        returns (
            uint256 _shared
        )
    {
        uint256 i = 0;
        while (_a.length > i && _b.length > i && _a[i] == _b[i]) {
            i++;
        }
        return i;
    }

    /**
     * @notice Utility; converts an RLP-encoded node into our nice struct.
     * @param _raw RLP-encoded node to convert.
     * @return _node Node as a TrieNode struct.
     */
    function _makeNode(
        bytes[] memory _raw
    )
        private
        pure
        returns (
            TrieNode memory _node
        )
    {
        bytes memory encoded = Lib_RLPWriter.writeList(_raw);

        return TrieNode({
            encoded: encoded,
            decoded: Lib_RLPReader.readList(encoded)
        });
    }

    /**
     * @notice Utility; converts an RLP-decoded node into our nice struct.
     * @param _items RLP-decoded node to convert.
     * @return _node Node as a TrieNode struct.
     */
    function _makeNode(
        Lib_RLPReader.RLPItem[] memory _items
    )
        private
        pure
        returns (
            TrieNode memory _node
        )
    {
        bytes[] memory raw = new bytes[](_items.length);
        for (uint256 i = 0; i < _items.length; i++) {
            raw[i] = Lib_RLPReader.readRawBytes(_items[i]);
        }
        return _makeNode(raw);
    }

    /**
     * @notice Creates a new extension node.
     * @param _key Key for the extension node, unprefixed.
     * @param _value Value for the extension node.
     * @return _node New extension node with the given k/v pair.
     */
    function _makeExtensionNode(
        bytes memory _key,
        bytes memory _value
    )
        private
        pure
        returns (
            TrieNode memory _node
        )
    {
        bytes[] memory raw = new bytes[](2);
        bytes memory key = _addHexPrefix(_key, false);
        raw[0] = Lib_RLPWriter.writeBytes(Lib_BytesUtils.fromNibbles(key));
        raw[1] = Lib_RLPWriter.writeBytes(_value);
        return _makeNode(raw);
    }

    /**
     * @notice Creates a new leaf node.
     * @dev This function is essentially identical to `_makeExtensionNode`.
     * Although we could route both to a single method with a flag, it's
     * more gas efficient to keep them separate and duplicate the logic.
     * @param _key Key for the leaf node, unprefixed.
     * @param _value Value for the leaf node.
     * @return _node New leaf node with the given k/v pair.
     */
    function _makeLeafNode(
        bytes memory _key,
        bytes memory _value
    )
        private
        pure
        returns (
            TrieNode memory _node
        )
    {
        bytes[] memory raw = new bytes[](2);
        bytes memory key = _addHexPrefix(_key, true);
        raw[0] = Lib_RLPWriter.writeBytes(Lib_BytesUtils.fromNibbles(key));
        raw[1] = Lib_RLPWriter.writeBytes(_value);
        return _makeNode(raw);
    }

    /**
     * @notice Creates an empty branch node.
     * @return _node Empty branch node as a TrieNode struct.
     */
    function _makeEmptyBranchNode()
        private
        pure
        returns (
            TrieNode memory _node
        )
    {
        bytes[] memory raw = new bytes[](BRANCH_NODE_LENGTH);
        for (uint256 i = 0; i < raw.length; i++) {
            raw[i] = RLP_NULL_BYTES;
        }
        return _makeNode(raw);
    }

    /**
     * @notice Modifies the value slot for a given branch.
     * @param _branch Branch node to modify.
     * @param _value Value to insert into the branch.
     * @return _updatedNode Modified branch node.
     */
    function _editBranchValue(
        TrieNode memory _branch,
        bytes memory _value
    )
        private
        pure
        returns (
            TrieNode memory _updatedNode
        )
    {
        bytes memory encoded = Lib_RLPWriter.writeBytes(_value);
        _branch.decoded[_branch.decoded.length - 1] = Lib_RLPReader.toRLPItem(encoded);
        return _makeNode(_branch.decoded);
    }

    /**
     * @notice Modifies a slot at an index for a given branch.
     * @param _branch Branch node to modify.
     * @param _index Slot index to modify.
     * @param _value Value to insert into the slot.
     * @return _updatedNode Modified branch node.
     */
    function _editBranchIndex(
        TrieNode memory _branch,
        uint8 _index,
        bytes memory _value
    )
        private
        pure
        returns (
            TrieNode memory _updatedNode
        )
    {
        bytes memory encoded = _value.length < 32 ? _value : Lib_RLPWriter.writeBytes(_value);
        _branch.decoded[_index] = Lib_RLPReader.toRLPItem(encoded);
        return _makeNode(_branch.decoded);
    }

    /**
     * @notice Utility; adds a prefix to a key.
     * @param _key Key to prefix.
     * @param _isLeaf Whether or not the key belongs to a leaf.
     * @return _prefixedKey Prefixed key.
     */
    function _addHexPrefix(
        bytes memory _key,
        bool _isLeaf
    )
        private
        pure
        returns (
            bytes memory _prefixedKey
        )
    {
        uint8 prefix = _isLeaf ? uint8(0x02) : uint8(0x00);
        uint8 offset = uint8(_key.length % 2);
        bytes memory prefixed = new bytes(2 - offset);
        prefixed[0] = bytes1(prefix + offset);
        return abi.encodePacked(prefixed, _key);
    }

    /**
     * @notice Utility; removes a prefix from a path.
     * @param _path Path to remove the prefix from.
     * @return _unprefixedKey Unprefixed key.
     */
    function _removeHexPrefix(
        bytes memory _path
    )
        private
        pure
        returns (
            bytes memory _unprefixedKey
        )
    {
        if (uint8(_path[0]) % 2 == 0) {
            return Lib_BytesUtils.slice(_path, 2);
        } else {
            return Lib_BytesUtils.slice(_path, 1);
        }
    }

    /**
     * @notice Utility; combines two node arrays. Array lengths are required
     * because the actual lengths may be longer than the filled lengths.
     * Array resizing is extremely costly and should be avoided.
     * @param _a First array to join.
     * @param _aLength Length of the first array.
     * @param _b Second array to join.
     * @param _bLength Length of the second array.
     * @return _joined Combined node array.
     */
    function _joinNodeArrays(
        TrieNode[] memory _a,
        uint256 _aLength,
        TrieNode[] memory _b,
        uint256 _bLength
    )
        private
        pure
        returns (
            TrieNode[] memory _joined
        )
    {
        TrieNode[] memory ret = new TrieNode[](_aLength + _bLength);

        // Copy elements from the first array.
        for (uint256 i = 0; i < _aLength; i++) {
            ret[i] = _a[i];
        }

        // Copy elements from the second array.
        for (uint256 i = 0; i < _bLength; i++) {
            ret[i + _aLength] = _b[i];
        }

        return ret;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/trie/Lib_SecureMerkleTrie.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */

/**
 * @title Lib_SecureMerkleTrie
 */
library Lib_SecureMerkleTrie {

    /**********************
     * Internal Functions *
     **********************/

    /**
     * @notice Verifies a proof that a given key/value pair is present in the
     * Merkle trie.
     * @param _key Key of the node to search for, as a hex string.
     * @param _value Value of the node to search for, as a hex string.
     * @param _proof Merkle trie inclusion proof for the desired node. Unlike
     * traditional Merkle trees, this proof is executed top-down and consists
     * of a list of RLP-encoded nodes that make a path down to the target node.
     * @param _root Known root of the Merkle trie. Used to verify that the
     * included proof is correctly constructed.
     * @return _verified `true` if the k/v pair exists in the trie, `false` otherwise.
     */
    function verifyInclusionProof(
        bytes memory _key,
        bytes memory _value,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bool _verified
        )
    {
        bytes memory key = _getSecureKey(_key);
        return Lib_MerkleTrie.verifyInclusionProof(key, _value, _proof, _root);
    }

    /**
     * @notice Verifies a proof that a given key is *not* present in
     * the Merkle trie.
     * @param _key Key of the node to search for, as a hex string.
     * @param _proof Merkle trie inclusion proof for the node *nearest* the
     * target node.
     * @param _root Known root of the Merkle trie. Used to verify that the
     * included proof is correctly constructed.
     * @return _verified `true` if the key is not present in the trie, `false` otherwise.
     */
    function verifyExclusionProof(
        bytes memory _key,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bool _verified
        )
    {
        bytes memory key = _getSecureKey(_key);
        return Lib_MerkleTrie.verifyExclusionProof(key, _proof, _root);
    }

    /**
     * @notice Updates a Merkle trie and returns a new root hash.
     * @param _key Key of the node to update, as a hex string.
     * @param _value Value of the node to update, as a hex string.
     * @param _proof Merkle trie inclusion proof for the node *nearest* the
     * target node. If the key exists, we can simply update the value.
     * Otherwise, we need to modify the trie to handle the new k/v pair.
     * @param _root Known root of the Merkle trie. Used to verify that the
     * included proof is correctly constructed.
     * @return _updatedRoot Root hash of the newly constructed trie.
     */
    function update(
        bytes memory _key,
        bytes memory _value,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bytes32 _updatedRoot
        )
    {
        bytes memory key = _getSecureKey(_key);
        return Lib_MerkleTrie.update(key, _value, _proof, _root);
    }

    /**
     * @notice Retrieves the value associated with a given key.
     * @param _key Key to search for, as hex bytes.
     * @param _proof Merkle trie inclusion proof for the key.
     * @param _root Known root of the Merkle trie.
     * @return _exists Whether or not the key exists.
     * @return _value Value of the key if it exists.
     */
    function get(
        bytes memory _key,
        bytes memory _proof,
        bytes32 _root
    )
        internal
        pure
        returns (
            bool _exists,
            bytes memory _value
        )
    {
        bytes memory key = _getSecureKey(_key);
        return Lib_MerkleTrie.get(key, _proof, _root);
    }

    /**
     * Computes the root hash for a trie with a single node.
     * @param _key Key for the single node.
     * @param _value Value for the single node.
     * @return _updatedRoot Hash of the trie.
     */
    function getSingleNodeRootHash(
        bytes memory _key,
        bytes memory _value
    )
        internal
        pure
        returns (
            bytes32 _updatedRoot
        )
    {
        bytes memory key = _getSecureKey(_key);
        return Lib_MerkleTrie.getSingleNodeRootHash(key, _value);
    }


    /*********************
     * Private Functions *
     *********************/

    /**
     * Computes the secure counterpart to a key.
     * @param _key Key to get a secure key from.
     * @return _secureKey Secure version of the key.
     */
    function _getSecureKey(
        bytes memory _key
    )
        private
        pure
        returns (
            bytes memory _secureKey
        )
    {
        return abi.encodePacked(keccak256(_key));
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/libraries/utils/Lib_ReentrancyGuard.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract Lib_ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/bridge/messaging/iAbs_BaseCrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/**
 * @title iAbs_BaseCrossDomainMessenger
 */
interface iAbs_BaseCrossDomainMessenger {

    /**********
     * Events *
     **********/
    event SentMessage(bytes message);
    event RelayedMessage(bytes32 msgHash);

    /**********************
     * Contract Variables *
     **********************/
    function xDomainMessageSender() external view returns (address);

    /********************
     * Public Functions *
     ********************/

    /**
     * Sends a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        address _target,
        bytes calldata _message,
        uint32 _gasLimit
    ) external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/bridge/messaging/iOVM_L1CrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */

/* Interface Imports */

/**
 * @title iOVM_L1CrossDomainMessenger
 */
interface iOVM_L1CrossDomainMessenger is iAbs_BaseCrossDomainMessenger {

    /*******************
     * Data Structures *
     *******************/

    struct L2MessageInclusionProof {
        bytes32 stateRoot;
        Lib_OVMCodec.ChainBatchHeader stateRootBatchHeader;
        Lib_OVMCodec.ChainInclusionProof stateRootProof;
        bytes stateTrieWitness;
        bytes storageTrieWitness;
    }


    /********************
     * Public Functions *
     ********************/

    /**
     * Relays a cross domain message to a contract.
     * @param _target Target contract address.
     * @param _sender Message sender address.
     * @param _message Message to send to the target.
     * @param _messageNonce Nonce for the provided message.
     * @param _proof Inclusion proof for the given message.
     */
    function relayMessage(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce,
        L2MessageInclusionProof memory _proof
    ) external;

    /**
     * Replays a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _sender Original sender address.
     * @param _message Message to send to the target.
     * @param _messageNonce Nonce for the provided message.
     * @param _gasLimit Gas limit for the provided message.
     */
    function replayMessage(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce,
        uint32 _gasLimit
    ) external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/chain/iOVM_ChainStorageContainer.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;

/**
 * @title iOVM_ChainStorageContainer
 */
interface iOVM_ChainStorageContainer {

    /********************
     * Public Functions *
     ********************/

    /**
     * Sets the container's global metadata field. We're using `bytes27` here because we use five
     * bytes to maintain the length of the underlying data structure, meaning we have an extra
     * 27 bytes to store arbitrary data.
     * @param _globalMetadata New global metadata to set.
     */
    function setGlobalMetadata(
        bytes27 _globalMetadata
    )
        external;

    /**
     * Retrieves the container's global metadata field.
     * @return Container global metadata field.
     */
    function getGlobalMetadata()
        external
        view
        returns (
            bytes27
        );

    /**
     * Retrieves the number of objects stored in the container.
     * @return Number of objects in the container.
     */
    function length()
        external
        view
        returns (
            uint256
        );

    /**
     * Pushes an object into the container.
     * @param _object A 32 byte value to insert into the container.
     */
    function push(
        bytes32 _object
    )
        external;

    /**
     * Pushes an object into the container. Function allows setting the global metadata since
     * we'll need to touch the "length" storage slot anyway, which also contains the global
     * metadata (it's an optimization).
     * @param _object A 32 byte value to insert into the container.
     * @param _globalMetadata New global metadata for the container.
     */
    function push(
        bytes32 _object,
        bytes27 _globalMetadata
    )
        external;

    /**
     * Retrieves an object from the container.
     * @param _index Index of the particular object to access.
     * @return 32 byte object value.
     */
    function get(
        uint256 _index
    )
        external
        view
        returns (
            bytes32
        );

    /**
     * Removes all objects after and including a given index.
     * @param _index Object index to delete from.
     */
    function deleteElementsAfterInclusive(
        uint256 _index
    )
        external;

    /**
     * Removes all objects after and including a given index. Also allows setting the global
     * metadata field.
     * @param _index Object index to delete from.
     * @param _globalMetadata New global metadata for the container.
     */
    function deleteElementsAfterInclusive(
        uint256 _index,
        bytes27 _globalMetadata
    )
        external;

    /**
     * Marks an index as overwritable, meaing the underlying buffer can start to write values over
     * any objects before and including the given index.
     */
    function setNextOverwritableIndex(
        uint256 _index
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/chain/iOVM_CanonicalTransactionChain.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */

/* Interface Imports */

/**
 * @title iOVM_CanonicalTransactionChain
 */
interface iOVM_CanonicalTransactionChain {

    /**********
     * Events *
     **********/

    event TransactionEnqueued(
        address _l1TxOrigin,
        address _target,
        uint256 _gasLimit,
        bytes _data,
        uint256 _queueIndex,
        uint256 _timestamp
    );

    event QueueBatchAppended(
        uint256 _startingQueueIndex,
        uint256 _numQueueElements,
        uint256 _totalElements
    );

    event SequencerBatchAppended(
        uint256 _startingQueueIndex,
        uint256 _numQueueElements,
        uint256 _totalElements
    );

    event TransactionBatchAppended(
        uint256 indexed _batchIndex,
        bytes32 _batchRoot,
        uint256 _batchSize,
        uint256 _prevTotalElements,
        bytes _extraData
    );


    /***********
     * Structs *
     ***********/

    struct BatchContext {
        uint256 numSequencedTransactions;
        uint256 numSubsequentQueueTransactions;
        uint256 timestamp;
        uint256 blockNumber;
    }


    /********************
     * Public Functions *
     ********************/


    /**
     * Accesses the batch storage container.
     * @return Reference to the batch storage container.
     */
    function batches()
        external
        view
        returns (
            iOVM_ChainStorageContainer
        );

    /**
     * Accesses the queue storage container.
     * @return Reference to the queue storage container.
     */
    function queue()
        external
        view
        returns (
            iOVM_ChainStorageContainer
        );

    /**
     * Retrieves the total number of elements submitted.
     * @return _totalElements Total submitted elements.
     */
    function getTotalElements()
        external
        view
        returns (
            uint256 _totalElements
        );

    /**
     * Retrieves the total number of batches submitted.
     * @return _totalBatches Total submitted batches.
     */
    function getTotalBatches()
        external
        view
        returns (
            uint256 _totalBatches
        );

    /**
     * Returns the index of the next element to be enqueued.
     * @return Index for the next queue element.
     */
    function getNextQueueIndex()
        external
        view
        returns (
            uint40
        );

    /**
     * Gets the queue element at a particular index.
     * @param _index Index of the queue element to access.
     * @return _element Queue element at the given index.
     */
    function getQueueElement(
        uint256 _index
    )
        external
        view
        returns (
            Lib_OVMCodec.QueueElement memory _element
        );

    /**
     * Returns the timestamp of the last transaction.
     * @return Timestamp for the last transaction.
     */
    function getLastTimestamp()
        external
        view
        returns (
            uint40
        );

    /**
     * Returns the blocknumber of the last transaction.
     * @return Blocknumber for the last transaction.
     */
    function getLastBlockNumber()
        external
        view
        returns (
            uint40
        );

    /**
     * Get the number of queue elements which have not yet been included.
     * @return Number of pending queue elements.
     */
    function getNumPendingQueueElements()
        external
        view
        returns (
            uint40
        );

    /**
     * Retrieves the length of the queue, including
     * both pending and canonical transactions.
     * @return Length of the queue.
     */
    function getQueueLength()
        external
        view
        returns (
            uint40
        );


    /**
     * Adds a transaction to the queue.
     * @param _target Target contract to send the transaction to.
     * @param _gasLimit Gas limit for the given transaction.
     * @param _data Transaction data.
     */
    function enqueue(
        address _target,
        uint256 _gasLimit,
        bytes memory _data
    )
        external;

    /**
     * Appends a given number of queued transactions as a single batch.
     * @param _numQueuedTransactions Number of transactions to append.
     */
    function appendQueueBatch(
        uint256 _numQueuedTransactions
    )
        external;

    /**
     * Allows the sequencer to append a batch of transactions.
     * @dev This function uses a custom encoding scheme for efficiency reasons.
     * .param _shouldStartAtElement Specific batch we expect to start appending to.
     * .param _totalElementsToAppend Total number of batch elements we expect to append.
     * .param _contexts Array of batch contexts.
     * .param _transactionDataFields Array of raw transaction data.
     */
    function appendSequencerBatch(
        // uint40 _shouldStartAtElement,
        // uint24 _totalElementsToAppend,
        // BatchContext[] _contexts,
        // bytes[] _transactionDataFields
    )
        external;

    /**
     * Verifies whether a transaction is included in the chain.
     * @param _transaction Transaction to verify.
     * @param _txChainElement Transaction chain element corresponding to the transaction.
     * @param _batchHeader Header of the batch the transaction was included in.
     * @param _inclusionProof Inclusion proof for the provided transaction chain element.
     * @return True if the transaction exists in the CTC, false if not.
     */
    function verifyTransaction(
        Lib_OVMCodec.Transaction memory _transaction,
        Lib_OVMCodec.TransactionChainElement memory _txChainElement,
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader,
        Lib_OVMCodec.ChainInclusionProof memory _inclusionProof
    )
        external
        view
        returns (
            bool
        );
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/iOVM/chain/iOVM_StateCommitmentChain.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */

/**
 * @title iOVM_StateCommitmentChain
 */
interface iOVM_StateCommitmentChain {

    /**********
     * Events *
     **********/

    event StateBatchAppended(
        uint256 indexed _batchIndex,
        bytes32 _batchRoot,
        uint256 _batchSize,
        uint256 _prevTotalElements,
        bytes _extraData
    );

    event StateBatchDeleted(
        uint256 indexed _batchIndex,
        bytes32 _batchRoot
    );


    /********************
     * Public Functions *
     ********************/

    /**
     * Retrieves the total number of elements submitted.
     * @return _totalElements Total submitted elements.
     */
    function getTotalElements()
        external
        view
        returns (
            uint256 _totalElements
        );

    /**
     * Retrieves the total number of batches submitted.
     * @return _totalBatches Total submitted batches.
     */
    function getTotalBatches()
        external
        view
        returns (
            uint256 _totalBatches
        );

    /**
     * Retrieves the timestamp of the last batch submitted by the sequencer.
     * @return _lastSequencerTimestamp Last sequencer batch timestamp.
     */
    function getLastSequencerTimestamp()
        external
        view
        returns (
            uint256 _lastSequencerTimestamp
        );

    /**
     * Appends a batch of state roots to the chain.
     * @param _batch Batch of state roots.
     * @param _shouldStartAtElement Index of the element at which this batch should start.
     */
    function appendStateBatch(
        bytes32[] calldata _batch,
        uint256 _shouldStartAtElement
    )
        external;

    /**
     * Deletes all state roots after (and including) a given batch.
     * @param _batchHeader Header of the batch to start deleting from.
     */
    function deleteStateBatch(
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader
    )
        external;

    /**
     * Verifies a batch inclusion proof.
     * @param _element Hash of the element to verify a proof for.
     * @param _batchHeader Header of the batch in which the element was included.
     * @param _proof Merkle inclusion proof for the element.
     */
    function verifyStateCommitment(
        bytes32 _element,
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader,
        Lib_OVMCodec.ChainInclusionProof memory _proof
    )
        external
        view
        returns (
            bool _verified
        );

    /**
     * Checks whether a given batch is still inside its fraud proof window.
     * @param _batchHeader Header of the batch to check.
     * @return _inside Whether or not the batch is inside the fraud proof window.
     */
    function insideFraudProofWindow(
        Lib_OVMCodec.ChainBatchHeader memory _batchHeader
    )
        external
        view
        returns (
            bool _inside
        );
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/OVM/bridge/messaging/Abs_BaseCrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Interface Imports */

/* Library Imports */

/**
 * @title Abs_BaseCrossDomainMessenger
 * @dev The Base Cross Domain Messenger is an abstract contract providing the interface and common functionality used in the
 * L1 and L2 Cross Domain Messengers. It can also serve as a template for developers wishing to implement a custom bridge 
 * contract to suit their needs.
 *
 * Compiler used: defined by child contract
 * Runtime target: defined by child contract
 */
abstract contract Abs_BaseCrossDomainMessenger is iAbs_BaseCrossDomainMessenger, Lib_ReentrancyGuard {
    /**************
     *  Constants *
     **************/

    // The default x-domain message sender being set to a non-zero value makes
    // deployment a bit more expensive, but in exchange the refund on every call to
    // `relayMessage` by the L1 and L2 messengers will be higher.
    address internal constant DEFAULT_XDOMAIN_SENDER = 0x000000000000000000000000000000000000dEaD;

    /**********************
     * Contract Variables *
     **********************/

    mapping (bytes32 => bool) public relayedMessages;
    mapping (bytes32 => bool) public successfulMessages;
    mapping (bytes32 => bool) public sentMessages;
    uint256 public messageNonce;
    address internal xDomainMsgSender = DEFAULT_XDOMAIN_SENDER;

    /********************
     * Public Functions *
     ********************/

    constructor() Lib_ReentrancyGuard() {}

    function xDomainMessageSender() public override view returns (address) {
        require(xDomainMsgSender != DEFAULT_XDOMAIN_SENDER, "xDomainMessageSender is not set");
        return xDomainMsgSender;
    }

    /**
     * Sends a cross domain message to the target messenger.
     * @param _target Target contract address.
     * @param _message Message to send to the target.
     * @param _gasLimit Gas limit for the provided message.
     */
    function sendMessage(
        address _target,
        bytes memory _message,
        uint32 _gasLimit
    )
        override
        public
    {
        bytes memory xDomainCalldata = _getXDomainCalldata(
            _target,
            msg.sender,
            _message,
            messageNonce
        );

        messageNonce += 1;
        sentMessages[keccak256(xDomainCalldata)] = true;

        _sendXDomainMessage(xDomainCalldata, _gasLimit);
        emit SentMessage(xDomainCalldata);
    }

    /**********************
     * Internal Functions *
     **********************/

    /**
     * Generates the correct cross domain calldata for a message.
     * @param _target Target contract address.
     * @param _sender Message sender address.
     * @param _message Message to send to the target.
     * @param _messageNonce Nonce for the provided message.
     * @return ABI encoded cross domain calldata.
     */
    function _getXDomainCalldata(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce
    )
        internal
        pure
        returns (
            bytes memory
        )
    {
        return abi.encodeWithSignature(
            "relayMessage(address,address,bytes,uint256)",
            _target,
            _sender,
            _message,
            _messageNonce
        );
    }

    /**
     * Sends a cross domain message.
     * param // Message to send.
     * param // Gas limit for the provided message.
     */
    function _sendXDomainMessage(
        bytes memory, // _message,
        uint256 // _gasLimit
    )
        virtual
        internal
    {
        revert("Implement me in child contracts!");
    }
}

// File: ../sc_datasets/DAppSCAN/openzeppelin-Optimism/contracts-18e128343731b9bde23812ce932e24d81440b6b7/contracts/optimistic-ethereum/OVM/bridge/messaging/OVM_L1CrossDomainMessenger.sol

// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <0.8.0;
pragma experimental ABIEncoderV2;

/* Library Imports */





/* Interface Imports */



/* Contract Imports */

/**
 * @title OVM_L1CrossDomainMessenger
 * @dev The L1 Cross Domain Messenger contract sends messages from L1 to L2, and relays messages from L2 onto L1. 
 * In the event that a message sent from L1 to L2 is rejected for exceeding the L2 epoch gas limit, it can be resubmitted 
 * via this contract's replay function. 
 *
 * Compiler used: solc
 * Runtime target: EVM
 */
contract OVM_L1CrossDomainMessenger is iOVM_L1CrossDomainMessenger, Abs_BaseCrossDomainMessenger, Lib_AddressResolver {

    /***************
     * Constructor *
     ***************/

    /**
     * Pass a default zero address to the address resolver. This will be updated when initialized.
     */
    constructor()
        Lib_AddressResolver(address(0))
    {}

    /**
     * @param _libAddressManager Address of the Address Manager.
     */
    function initialize(
        address _libAddressManager
    )
        public
    {
        require(address(libAddressManager) == address(0), "L1CrossDomainMessenger already intialized.");
        libAddressManager = Lib_AddressManager(_libAddressManager);
        xDomainMsgSender = DEFAULT_XDOMAIN_SENDER;
    }


    /**********************
     * Function Modifiers *
     **********************/

    /**
     * Modifier to enforce that, if configured, only the OVM_L2MessageRelayer contract may successfully call a method.
     */
    modifier onlyRelayer() {
        address relayer = resolve("OVM_L2MessageRelayer");
        if (relayer != address(0)) {
            require(
                msg.sender == relayer,
                "Only OVM_L2MessageRelayer can relay L2-to-L1 messages."
            );
        }
        _;
    }


    /********************
     * Public Functions *
     ********************/

    /**
     * Relays a cross domain message to a contract.
     * @inheritdoc iOVM_L1CrossDomainMessenger
     */
    function relayMessage(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce,
        L2MessageInclusionProof memory _proof
    )
        override
        public
        nonReentrant
        onlyRelayer()
    {
        bytes memory xDomainCalldata = _getXDomainCalldata(
            _target,
            _sender,
            _message,
            _messageNonce
        );

        require(
            _verifyXDomainMessage(
                xDomainCalldata,
                _proof
            ) == true,
            "Provided message could not be verified."
        );

        bytes32 xDomainCalldataHash = keccak256(xDomainCalldata);

        require(
            successfulMessages[xDomainCalldataHash] == false,
            "Provided message has already been received."
        );

        xDomainMsgSender = _sender;
        (bool success, ) = _target.call(_message);
        xDomainMsgSender = DEFAULT_XDOMAIN_SENDER;

        // Mark the message as received if the call was successful. Ensures that a message can be
        // relayed multiple times in the case that the call reverted.
        if (success == true) {
            successfulMessages[xDomainCalldataHash] = true;
            emit RelayedMessage(xDomainCalldataHash);
        }

        // Store an identifier that can be used to prove that the given message was relayed by some
        // user. Gives us an easy way to pay relayers for their work.
        bytes32 relayId = keccak256(
            abi.encodePacked(
                xDomainCalldata,
                msg.sender,
                block.number
            )
        );
        relayedMessages[relayId] = true;
    }

    /**
     * Replays a cross domain message to the target messenger.
     * @inheritdoc iOVM_L1CrossDomainMessenger
     */
    function replayMessage(
        address _target,
        address _sender,
        bytes memory _message,
        uint256 _messageNonce,
        uint32 _gasLimit
    )
        override
        public
    {
        bytes memory xDomainCalldata = _getXDomainCalldata(
            _target,
            _sender,
            _message,
            _messageNonce
        );

        require(
            sentMessages[keccak256(xDomainCalldata)] == true,
            "Provided message has not already been sent."
        );

        _sendXDomainMessage(xDomainCalldata, _gasLimit);
    }


    /**********************
     * Internal Functions *
     **********************/

    /**
     * Verifies that the given message is valid.
     * @param _xDomainCalldata Calldata to verify.
     * @param _proof Inclusion proof for the message.
     * @return Whether or not the provided message is valid.
     */
    function _verifyXDomainMessage(
        bytes memory _xDomainCalldata,
        L2MessageInclusionProof memory _proof
    )
        internal
        view
        returns (
            bool
        )
    {
        return (
            _verifyStateRootProof(_proof)
            && _verifyStorageProof(_xDomainCalldata, _proof)
        );
    }

    /**
     * Verifies that the state root within an inclusion proof is valid.
     * @param _proof Message inclusion proof.
     * @return Whether or not the provided proof is valid.
     */
    function _verifyStateRootProof(
        L2MessageInclusionProof memory _proof
    )
        internal
        view
        returns (
            bool
        )
    {
        iOVM_StateCommitmentChain ovmStateCommitmentChain = iOVM_StateCommitmentChain(resolve("OVM_StateCommitmentChain"));

        return (
            ovmStateCommitmentChain.insideFraudProofWindow(_proof.stateRootBatchHeader) == false
            && ovmStateCommitmentChain.verifyStateCommitment(
                _proof.stateRoot,
                _proof.stateRootBatchHeader,
                _proof.stateRootProof
            )
        );
    }

    /**
     * Verifies that the storage proof within an inclusion proof is valid.
     * @param _xDomainCalldata Encoded message calldata.
     * @param _proof Message inclusion proof.
     * @return Whether or not the provided proof is valid.
     */
    function _verifyStorageProof(
        bytes memory _xDomainCalldata,
        L2MessageInclusionProof memory _proof
    )
        internal
        view
        returns (
            bool
        )
    {
        bytes32 storageKey = keccak256(
            abi.encodePacked(
                keccak256(
                    abi.encodePacked(
                        _xDomainCalldata,
                        resolve("OVM_L2CrossDomainMessenger")
                    )
                ),
                uint256(0)
            )
        );

        (
            bool exists,
            bytes memory encodedMessagePassingAccount
        ) = Lib_SecureMerkleTrie.get(
            abi.encodePacked(0x4200000000000000000000000000000000000000),
            _proof.stateTrieWitness,
            _proof.stateRoot
        );

        require(
            exists == true,
            "Message passing precompile has not been initialized or invalid proof provided."
        );

        Lib_OVMCodec.EVMAccount memory account = Lib_OVMCodec.decodeEVMAccount(
            encodedMessagePassingAccount
        );

        return Lib_SecureMerkleTrie.verifyInclusionProof(
            abi.encodePacked(storageKey),
            abi.encodePacked(uint8(1)),
            _proof.storageTrieWitness,
            account.storageRoot
        );
    }

    /**
     * Sends a cross domain message.
     * @param _message Message to send.
     * @param _gasLimit OVM gas limit for the message.
     */
    function _sendXDomainMessage(
        bytes memory _message,
        uint256 _gasLimit
    )
        override
        internal
    {
        iOVM_CanonicalTransactionChain(resolve("OVM_CanonicalTransactionChain")).enqueue(
            resolve("OVM_L2CrossDomainMessenger"),
            _gasLimit,
            _message
        );
    }
}
