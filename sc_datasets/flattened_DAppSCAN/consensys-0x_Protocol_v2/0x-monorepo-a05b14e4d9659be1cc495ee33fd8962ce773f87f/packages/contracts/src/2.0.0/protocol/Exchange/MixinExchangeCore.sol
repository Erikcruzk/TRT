// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/libs/LibConstants.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;


// solhint-disable max-line-length
contract LibConstants {
   
    // Asset data for ZRX token. Used for fee transfers.
    // @TODO: Hardcode constant when we deploy. Currently 
    //        not constant to make testing easier.

    // The proxyId for ZRX_ASSET_DATA is bytes4(keccak256("ERC20Token(address)")) = 0xf47261b0
    
    // Kovan ZRX address is 0x6ff6c0ff1d68b964901f986d4c9fa3ac68346570.
    // The ABI encoded proxyId and address is 0xf47261b00000000000000000000000006ff6c0ff1d68b964901f986d4c9fa3ac68346570
    // bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6f\xf6\xc0\xff\x1d\x68\xb9\x64\x90\x1f\x98\x6d\x4c\x9f\xa3\xac\x68\x34\x65\x70";
    
    // Mainnet ZRX address is 0xe41d2489571d322189246dafa5ebde1f4699f498.
    // The ABI encoded proxyId and address is 0xf47261b0000000000000000000000000e41d2489571d322189246dafa5ebde1f4699f498
    // bytes constant public ZRX_ASSET_DATA = "\xf4\x72\x61\xb0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe4\x1d\x24\x89\x57\x1d\x32\x21\x89\x24\x6d\xaf\xa5\xeb\xde\x1f\x46\x99\xf4\x98";
    
    // solhint-disable-next-line var-name-mixedcase
    bytes public ZRX_ASSET_DATA;

    // @TODO: Remove when we deploy.
    constructor (bytes memory zrxAssetData)
        public
    {
        ZRX_ASSET_DATA = zrxAssetData;
    }
}
// solhint-enable max-line-length

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/utils/SafeMath/SafeMath.sol

pragma solidity 0.4.24;


contract SafeMath {
    function safeMul(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(
            c / a == b,
            "UINT256_OVERFLOW"
        );
        return c;
    }

    function safeDiv(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        uint256 c = a / b;
        return c;
    }

    function safeSub(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        require(
            b <= a,
            "UINT256_UNDERFLOW"
        );
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        uint256 c = a + b;
        require(
            c >= a,
            "UINT256_OVERFLOW"
        );
        return c;
    }

    function max64(uint64 a, uint64 b)
        internal
        pure
        returns (uint256)
    {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b)
        internal
        pure
        returns (uint256)
    {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b)
        internal
        pure
        returns (uint256)
    {
        return a < b ? a : b;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/libs/LibFillResults.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;

contract LibFillResults is
    SafeMath
{

    struct FillResults {
        uint256 makerAssetFilledAmount;  // Total amount of makerAsset(s) filled.
        uint256 takerAssetFilledAmount;  // Total amount of takerAsset(s) filled.
        uint256 makerFeePaid;            // Total amount of ZRX paid by maker(s) to feeRecipient(s).
        uint256 takerFeePaid;            // Total amount of ZRX paid by taker to feeRecipients(s).
    }

    struct MatchedFillResults {
        FillResults left;                    // Amounts filled and fees paid of left order.
        FillResults right;                   // Amounts filled and fees paid of right order.
        uint256 leftMakerAssetSpreadAmount;  // Spread between price of left and right order, denominated in the left order's makerAsset, paid to taker.
    }

    /// @dev Adds properties of both FillResults instances.
    ///      Modifies the first FillResults instance specified.
    /// @param totalFillResults Fill results instance that will be added onto.
    /// @param singleFillResults Fill results instance that will be added to totalFillResults.
    function addFillResults(FillResults memory totalFillResults, FillResults memory singleFillResults)
        internal
        pure
    {
        totalFillResults.makerAssetFilledAmount = safeAdd(totalFillResults.makerAssetFilledAmount, singleFillResults.makerAssetFilledAmount);
        totalFillResults.takerAssetFilledAmount = safeAdd(totalFillResults.takerAssetFilledAmount, singleFillResults.takerAssetFilledAmount);
        totalFillResults.makerFeePaid = safeAdd(totalFillResults.makerFeePaid, singleFillResults.makerFeePaid);
        totalFillResults.takerFeePaid = safeAdd(totalFillResults.takerFeePaid, singleFillResults.takerFeePaid);
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/libs/LibEIP712.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;


contract LibEIP712 {
    // EIP191 header for EIP712 prefix
    string constant internal EIP191_HEADER = "\x19\x01";

    // EIP712 Domain Name value
    string constant internal EIP712_DOMAIN_NAME = "0x Protocol";

    // EIP712 Domain Version value
    string constant internal EIP712_DOMAIN_VERSION = "2";

    // Hash of the EIP712 Domain Separator Schema
    bytes32 public constant EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH = keccak256(abi.encodePacked(
        "EIP712Domain(",
        "string name,",
        "string version,",
        "address verifyingContract",
        ")"
    ));

    // Hash of the EIP712 Domain Separator data
    // solhint-disable-next-line var-name-mixedcase
    bytes32 public EIP712_DOMAIN_HASH;

    constructor ()
        public
    {
        EIP712_DOMAIN_HASH = keccak256(abi.encode(
            EIP712_DOMAIN_SEPARATOR_SCHEMA_HASH,
            keccak256(bytes(EIP712_DOMAIN_NAME)),
            keccak256(bytes(EIP712_DOMAIN_VERSION)),
            address(this)
        ));
    }

    /// @dev Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
    /// @param hashStruct The EIP712 hash struct.
    /// @return EIP712 hash applied to this EIP712 Domain.
    function hashEIP712Message(bytes32 hashStruct)
        internal
        view
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(EIP191_HEADER, EIP712_DOMAIN_HASH, hashStruct));
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/libs/LibOrder.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;

contract LibOrder is
    LibEIP712
{

    // Hash for the EIP712 Order Schema
    bytes32 constant internal EIP712_ORDER_SCHEMA_HASH = keccak256(abi.encodePacked(
        "Order(",
        "address makerAddress,",
        "address takerAddress,",
        "address feeRecipientAddress,",
        "address senderAddress,",
        "uint256 makerAssetAmount,",
        "uint256 takerAssetAmount,",
        "uint256 makerFee,",
        "uint256 takerFee,",
        "uint256 expirationTimeSeconds,",
        "uint256 salt,",
        "bytes makerAssetData,",
        "bytes takerAssetData",
        ")"
    ));

    // A valid order remains fillable until it is expired, fully filled, or cancelled.
    // An order's state is unaffected by external factors, like account balances.
    enum OrderStatus {
        INVALID,                     // Default value
        INVALID_MAKER_ASSET_AMOUNT,  // Order does not have a valid maker asset amount
        INVALID_TAKER_ASSET_AMOUNT,  // Order does not have a valid taker asset amount
        FILLABLE,                    // Order is fillable
        EXPIRED,                     // Order has already expired
        FULLY_FILLED,                // Order is fully filled
        CANCELLED                    // Order has been cancelled
    }

    // solhint-disable max-line-length
    struct Order {
        address makerAddress;           // Address that created the order.      
        address takerAddress;           // Address that is allowed to fill the order. If set to 0, any address is allowed to fill the order.          
        address feeRecipientAddress;    // Address that will recieve fees when order is filled.      
        address senderAddress;          // Address that is allowed to call Exchange contract methods that affect this order. If set to 0, any address is allowed to call these methods.
        uint256 makerAssetAmount;       // Amount of makerAsset being offered by maker. Must be greater than 0.        
        uint256 takerAssetAmount;       // Amount of takerAsset being bid on by maker. Must be greater than 0.        
        uint256 makerFee;               // Amount of ZRX paid to feeRecipient by maker when order is filled. If set to 0, no transfer of ZRX from maker to feeRecipient will be attempted.
        uint256 takerFee;               // Amount of ZRX paid to feeRecipient by taker when order is filled. If set to 0, no transfer of ZRX from taker to feeRecipient will be attempted.
        uint256 expirationTimeSeconds;  // Timestamp in seconds at which order expires.          
        uint256 salt;                   // Arbitrary number to facilitate uniqueness of the order's hash.     
        bytes makerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring makerAsset. The last byte references the id of this proxy.
        bytes takerAssetData;           // Encoded data that can be decoded by a specified proxy contract when transferring takerAsset. The last byte references the id of this proxy.
    }
    // solhint-enable max-line-length

    struct OrderInfo {
        uint8 orderStatus;                    // Status that describes order's validity and fillability.
        bytes32 orderHash;                    // EIP712 hash of the order (see LibOrder.getOrderHash).
        uint256 orderTakerAssetFilledAmount;  // Amount of order that has already been filled.
    }

    /// @dev Calculates Keccak-256 hash of the order.
    /// @param order The order structure.
    /// @return Keccak-256 EIP712 hash of the order.
    function getOrderHash(Order memory order)
        internal
        view
        returns (bytes32 orderHash)
    {
        orderHash = hashEIP712Message(hashOrder(order));
        return orderHash;
    }

    /// @dev Calculates EIP712 hash of the order.
    /// @param order The order structure.
    /// @return EIP712 hash of the order.
    function hashOrder(Order memory order)
        internal
        pure
        returns (bytes32 result)
    {
        bytes32 schemaHash = EIP712_ORDER_SCHEMA_HASH;
        bytes32 makerAssetDataHash = keccak256(order.makerAssetData);
        bytes32 takerAssetDataHash = keccak256(order.takerAssetData);

        // Assembly for more efficiently computing:
        // keccak256(abi.encode(
        //     order.makerAddress,
        //     order.takerAddress,
        //     order.feeRecipientAddress,
        //     order.senderAddress,
        //     order.makerAssetAmount,
        //     order.takerAssetAmount,
        //     order.makerFee,
        //     order.takerFee,
        //     order.expirationTimeSeconds,
        //     order.salt,
        //     keccak256(order.makerAssetData),
        //     keccak256(order.takerAssetData)
        // ));

        assembly {
            // Backup
            // solhint-disable-next-line space-after-comma
            let temp1 := mload(sub(order,  32))
            let temp2 := mload(add(order, 320))
            let temp3 := mload(add(order, 352))
            
            // Hash in place
            // solhint-disable-next-line space-after-comma
            mstore(sub(order,  32), schemaHash)
            mstore(add(order, 320), makerAssetDataHash)
            mstore(add(order, 352), takerAssetDataHash)
            result := keccak256(sub(order, 32), 416)
            
            // Restore
            // solhint-disable-next-line space-after-comma
            mstore(sub(order,  32), temp1)
            mstore(add(order, 320), temp2)
            mstore(add(order, 352), temp3)
        }
        return result;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/libs/LibMath.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;

contract LibMath is
    SafeMath
{

    /// @dev Calculates partial value given a numerator and denominator.
    /// @param numerator Numerator.
    /// @param denominator Denominator.
    /// @param target Value to calculate partial of.
    /// @return Partial value of target.
    function getPartialAmount(
        uint256 numerator,
        uint256 denominator,
        uint256 target
    )
        internal
        pure
        returns (uint256 partialAmount)
    {
        partialAmount = safeDiv(
            safeMul(numerator, target),
            denominator
        );
        return partialAmount;
    }

    /// @dev Checks if rounding error > 0.1%.
    /// @param numerator Numerator.
    /// @param denominator Denominator.
    /// @param target Value to multiply with numerator/denominator.
    /// @return Rounding error is present.
    function isRoundingError(
        uint256 numerator,
        uint256 denominator,
        uint256 target
    )
        internal
        pure
        returns (bool isError)
    {
        uint256 remainder = mulmod(target, numerator, denominator);
        if (remainder == 0) {
            return false; // No rounding error.
        }

        uint256 errPercentageTimes1000000 = safeDiv(
            safeMul(remainder, 1000000),
            safeMul(numerator, target)
        );
        isError = errPercentageTimes1000000 > 1000;
        return isError;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/IExchangeCore.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;


contract IExchangeCore {

    /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
    ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
    /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
    function cancelOrdersUpTo(uint256 targetOrderEpoch)
        external;

    /// @dev Fills the input order.
    /// @param order Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    /// @return Amounts filled and fees paid by maker and taker.
    function fillOrder(
        LibOrder.Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        public
        returns (LibFillResults.FillResults memory fillResults);

    /// @dev After calling, the order can not be filled anymore.
    /// @param order Order struct containing order specifications.
    function cancelOrder(LibOrder.Order memory order)
        public;

    /// @dev Gets information about an order: status, hash, and amount filled.
    /// @param order Order to gather information on.
    /// @return OrderInfo Information about the order and its state.
    ///                   See LibOrder.OrderInfo for a complete description.
    function getOrderInfo(LibOrder.Order memory order)
        public
        view
        returns (LibOrder.OrderInfo memory orderInfo);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/mixins/MExchangeCore.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;



contract MExchangeCore is
    IExchangeCore
{
    // Fill event is emitted whenever an order is filled.
    event Fill(
        address indexed makerAddress,         // Address that created the order.      
        address indexed feeRecipientAddress,  // Address that received fees.
        address takerAddress,                 // Address that filled the order.
        address senderAddress,                // Address that called the Exchange contract (msg.sender).
        uint256 makerAssetFilledAmount,       // Amount of makerAsset sold by maker and bought by taker. 
        uint256 takerAssetFilledAmount,       // Amount of takerAsset sold by taker and bought by maker.
        uint256 makerFeePaid,                 // Amount of ZRX paid to feeRecipient by maker.
        uint256 takerFeePaid,                 // Amount of ZRX paid to feeRecipient by taker.
        bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
        bytes makerAssetData,                 // Encoded data specific to makerAsset. 
        bytes takerAssetData                  // Encoded data specific to takerAsset.
    );

    // Cancel event is emitted whenever an individual order is cancelled.
    event Cancel(
        address indexed makerAddress,         // Address that created the order.      
        address indexed feeRecipientAddress,  // Address that would have recieved fees if order was filled.   
        address senderAddress,                // Address that called the Exchange contract (msg.sender).
        bytes32 indexed orderHash,            // EIP712 hash of order (see LibOrder.getOrderHash).
        bytes makerAssetData,                 // Encoded data specific to makerAsset. 
        bytes takerAssetData                  // Encoded data specific to takerAsset.
    );

    // CancelUpTo event is emitted whenever `cancelOrdersUpTo` is executed succesfully.
    event CancelUpTo(
        address indexed makerAddress,         // Orders cancelled must have been created by this address.
        address indexed senderAddress,        // Orders cancelled must have a `senderAddress` equal to this address.
        uint256 orderEpoch                    // Orders specified makerAddress and senderAddress with a salt <= this value are considered cancelled.
    );

    /// @dev Updates state with results of a fill order.
    /// @param order that was filled.
    /// @param takerAddress Address of taker who filled the order.
    /// @param orderTakerAssetFilledAmount Amount of order already filled.
    /// @return fillResults Amounts filled and fees paid by maker and taker.
    function updateFilledState(
        LibOrder.Order memory order,
        address takerAddress,
        bytes32 orderHash,
        uint256 orderTakerAssetFilledAmount,
        LibFillResults.FillResults memory fillResults
    )
        internal;

    /// @dev Updates state with results of cancelling an order.
    ///      State is only updated if the order is currently fillable.
    ///      Otherwise, updating state would have no effect.
    /// @param order that was cancelled.
    /// @param orderHash Hash of order that was cancelled.
    function updateCancelledState(
        LibOrder.Order memory order,
        bytes32 orderHash
    )
        internal;

    /// @dev Validates context for fillOrder. Succeeds or throws.
    /// @param order to be filled.
    /// @param orderInfo Status, orderHash, and amount already filled of order.
    /// @param takerAddress Address of order taker.
    /// @param takerAssetFillAmount Desired amount of order to fill by taker.
    /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
    /// @param signature Proof that the orders was created by its maker.
    function assertValidFill(
        LibOrder.Order memory order,
        LibOrder.OrderInfo memory orderInfo,
        address takerAddress,
        uint256 takerAssetFillAmount,
        uint256 takerAssetFilledAmount,
        bytes memory signature
    )
        internal
        view;

    /// @dev Validates context for cancelOrder. Succeeds or throws.
    /// @param order to be cancelled.
    /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
    function assertValidCancel(
        LibOrder.Order memory order,
        LibOrder.OrderInfo memory orderInfo
    )
        internal
        view;

    /// @dev Calculates amounts filled and fees paid by maker and taker.
    /// @param order to be filled.
    /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
    /// @return fillResults Amounts filled and fees paid by maker and taker.
    function calculateFillResults(
        LibOrder.Order memory order,
        uint256 takerAssetFilledAmount
    )
        internal
        pure
        returns (LibFillResults.FillResults memory fillResults);

}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/ISignatureValidator.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;


contract ISignatureValidator {

    /// @dev Approves a hash on-chain using any valid signature type.
    ///      After presigning a hash, the preSign signature type will become valid for that hash and signer.
    /// @param signerAddress Address that should have signed the given hash.
    /// @param signature Proof that the hash has been signed by signer.
    function preSign(
        bytes32 hash,
        address signerAddress,
        bytes signature
    )
        external;
    
    /// @dev Approves/unnapproves a Validator contract to verify signatures on signer's behalf.
    /// @param validatorAddress Address of Validator contract.
    /// @param approval Approval or disapproval of  Validator contract.
    function setSignatureValidatorApproval(
        address validatorAddress,
        bool approval
    )
        external;

    /// @dev Verifies that a signature is valid.
    /// @param hash Message hash that is signed.
    /// @param signerAddress Address of signer.
    /// @param signature Proof of signing.
    /// @return Validity of order signature.
    function isValidSignature(
        bytes32 hash,
        address signerAddress,
        bytes memory signature
    )
        public
        view
        returns (bool isValid);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/mixins/MSignatureValidator.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;

contract MSignatureValidator is
    ISignatureValidator
{
    event SignatureValidatorApproval(
        address indexed signerAddress,     // Address that approves or disapproves a contract to verify signatures.
        address indexed validatorAddress,  // Address of signature validator contract.
        bool approved                      // Approval or disapproval of validator contract.
    );

    // Allowed signature types.
    enum SignatureType {
        Illegal,         // 0x00, default value
        Invalid,         // 0x01
        EIP712,          // 0x02
        EthSign,         // 0x03
        Caller,          // 0x04
        Wallet,          // 0x05
        Validator,       // 0x06
        PreSigned,       // 0x07
        Trezor,          // 0x08
        NSignatureTypes  // 0x09, number of signature types. Always leave at end.
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/ITransactions.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/
pragma solidity 0.4.24;


contract ITransactions {

    /// @dev Executes an exchange method call in the context of signer.
    /// @param salt Arbitrary number to ensure uniqueness of transaction hash.
    /// @param signerAddress Address of transaction signer.
    /// @param data AbiV2 encoded calldata.
    /// @param signature Proof of signer transaction by signer.
    function executeTransaction(
        uint256 salt,
        address signerAddress,
        bytes data,
        bytes signature
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/mixins/MTransactions.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/
pragma solidity 0.4.24;

contract MTransactions is
    ITransactions
{

    /// @dev The current function will be called in the context of this address (either 0x transaction signer or `msg.sender`).
    ///      If calling a fill function, this address will represent the taker.
    ///      If calling a cancel function, this address will represent the maker.
    /// @return Signer of 0x transaction if entry point is `executeTransaction`.
    ///         `msg.sender` if entry point is any other function.
    function getCurrentContextAddress()
        internal
        view
        returns (address);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/IAssetProxyDispatcher.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;


contract IAssetProxyDispatcher {

    /// @dev Registers an asset proxy to its asset proxy id.
    ///      Once an asset proxy is registered, it cannot be unregistered.
    /// @param assetProxy Address of new asset proxy to register.
    function registerAssetProxy(address assetProxy)
        external;

    /// @dev Gets an asset proxy.
    /// @param assetProxyId Id of the asset proxy.
    /// @return The asset proxy registered to assetProxyId. Returns 0x0 if no proxy is registered.
    function getAssetProxy(bytes4 assetProxyId)
        external
        view
        returns (address);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/mixins/MAssetProxyDispatcher.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;

contract MAssetProxyDispatcher is
    IAssetProxyDispatcher
{

    // Logs registration of new asset proxy
    event AssetProxyRegistered(
        bytes4 id,              // Id of new registered AssetProxy.
        address assetProxy      // Address of new registered AssetProxy.
    );

    /// @dev Forwards arguments to assetProxy and calls `transferFrom`. Either succeeds or throws.
    /// @param assetData Byte array encoded for the asset.
    /// @param from Address to transfer token from.
    /// @param to Address to transfer token to.
    /// @param amount Amount of token to transfer.
    function dispatchTransferFrom(
        bytes memory assetData,
        address from,
        address to,
        uint256 amount
    )
        internal;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/MixinExchangeCore.sol

/*

  Copyright 2018 ZeroEx Intl.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

pragma solidity 0.4.24;
pragma experimental ABIEncoderV2;








contract MixinExchangeCore is
    LibConstants,
    LibMath,
    LibOrder,
    LibFillResults,
    MAssetProxyDispatcher,
    MExchangeCore,
    MSignatureValidator,
    MTransactions
{
    // Mapping of orderHash => amount of takerAsset already bought by maker
    mapping (bytes32 => uint256) public filled;

    // Mapping of orderHash => cancelled
    mapping (bytes32 => bool) public cancelled;

    // Mapping of makerAddress => senderAddress => lowest salt an order can have in order to be fillable
    // Orders with specified senderAddress and with a salt less than their epoch to are considered cancelled
    mapping (address => mapping (address => uint256)) public orderEpoch;

    /// @dev Cancels all orders created by makerAddress with a salt less than or equal to the targetOrderEpoch
    ///      and senderAddress equal to msg.sender (or null address if msg.sender == makerAddress).
    /// @param targetOrderEpoch Orders created with a salt less or equal to this value will be cancelled.
    function cancelOrdersUpTo(uint256 targetOrderEpoch)
        external
    {
        address makerAddress = getCurrentContextAddress();
        // If this function is called via `executeTransaction`, we only update the orderEpoch for the makerAddress/msg.sender combination.
        // This allows external filter contracts to add rules to how orders are cancelled via this function.
        address senderAddress = makerAddress == msg.sender ? address(0) : msg.sender;

        // orderEpoch is initialized to 0, so to cancelUpTo we need salt + 1
        uint256 newOrderEpoch = targetOrderEpoch + 1;  
        uint256 oldOrderEpoch = orderEpoch[makerAddress][senderAddress];

        // Ensure orderEpoch is monotonically increasing
        require(
            newOrderEpoch > oldOrderEpoch, 
            "INVALID_NEW_ORDER_EPOCH"
        );

        // Update orderEpoch
        orderEpoch[makerAddress][senderAddress] = newOrderEpoch;
        emit CancelUpTo(makerAddress, senderAddress, newOrderEpoch);
    }

    /// @dev Fills the input order.
    /// @param order Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    /// @return Amounts filled and fees paid by maker and taker.
    function fillOrder(
        Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        public
        returns (FillResults memory fillResults)
    {
        // Fetch order info
        OrderInfo memory orderInfo = getOrderInfo(order);

        // Fetch taker address
        address takerAddress = getCurrentContextAddress();

        // Get amount of takerAsset to fill
        uint256 remainingTakerAssetAmount = safeSub(order.takerAssetAmount, orderInfo.orderTakerAssetFilledAmount);
        uint256 takerAssetFilledAmount = min256(takerAssetFillAmount, remainingTakerAssetAmount);

        // Validate context
        assertValidFill(
            order,
            orderInfo,
            takerAddress,
            takerAssetFillAmount,
            takerAssetFilledAmount,
            signature
        );

        // Compute proportional fill amounts
        fillResults = calculateFillResults(order, takerAssetFilledAmount);

        // Update exchange internal state
        updateFilledState(
            order,
            takerAddress,
            orderInfo.orderHash,
            orderInfo.orderTakerAssetFilledAmount,
            fillResults
        );
    
        // Settle order
        settleOrder(order, takerAddress, fillResults);

        return fillResults;
    }

    /// @dev After calling, the order can not be filled anymore.
    ///      Throws if order is invalid or sender does not have permission to cancel.
    /// @param order Order to cancel. Order must be OrderStatus.FILLABLE.
    function cancelOrder(Order memory order)
        public
    {
        // Fetch current order status
        OrderInfo memory orderInfo = getOrderInfo(order);

        // Validate context
        assertValidCancel(order, orderInfo);

        // Perform cancel
        updateCancelledState(order, orderInfo.orderHash);
    }

    /// @dev Gets information about an order: status, hash, and amount filled.
    /// @param order Order to gather information on.
    /// @return OrderInfo Information about the order and its state.
    ///         See LibOrder.OrderInfo for a complete description.
    function getOrderInfo(Order memory order)
        public
        view
        returns (OrderInfo memory orderInfo)
    {
        // Compute the order hash
        orderInfo.orderHash = getOrderHash(order);

        // Fetch filled amount
        orderInfo.orderTakerAssetFilledAmount = filled[orderInfo.orderHash];

        // If order.makerAssetAmount is zero, we also reject the order.
        // While the Exchange contract handles them correctly, they create
        // edge cases in the supporting infrastructure because they have
        // an 'infinite' price when computed by a simple division.
        if (order.makerAssetAmount == 0) {
            orderInfo.orderStatus = uint8(OrderStatus.INVALID_MAKER_ASSET_AMOUNT);
            return orderInfo;
        }

        // If order.takerAssetAmount is zero, then the order will always
        // be considered filled because 0 == takerAssetAmount == orderTakerAssetFilledAmount
        // Instead of distinguishing between unfilled and filled zero taker
        // amount orders, we choose not to support them.
        if (order.takerAssetAmount == 0) {
            orderInfo.orderStatus = uint8(OrderStatus.INVALID_TAKER_ASSET_AMOUNT);
            return orderInfo;
        }

        // Validate order availability
        if (orderInfo.orderTakerAssetFilledAmount >= order.takerAssetAmount) {
            orderInfo.orderStatus = uint8(OrderStatus.FULLY_FILLED);
            return orderInfo;
        }

        // Validate order expiration
        // solhint-disable-next-line not-rely-on-time
        if (block.timestamp >= order.expirationTimeSeconds) {
            orderInfo.orderStatus = uint8(OrderStatus.EXPIRED);
            return orderInfo;
        }

        // Check if order has been cancelled
        if (cancelled[orderInfo.orderHash]) {
            orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
            return orderInfo;
        }
        if (orderEpoch[order.makerAddress][order.senderAddress] > order.salt) {
            orderInfo.orderStatus = uint8(OrderStatus.CANCELLED);
            return orderInfo;
        }

        // All other statuses are ruled out: order is Fillable
        orderInfo.orderStatus = uint8(OrderStatus.FILLABLE);
        return orderInfo;
    }

    /// @dev Updates state with results of a fill order.
    /// @param order that was filled.
    /// @param takerAddress Address of taker who filled the order.
    /// @param orderTakerAssetFilledAmount Amount of order already filled.
    /// @return fillResults Amounts filled and fees paid by maker and taker.
    function updateFilledState(
        Order memory order,
        address takerAddress,
        bytes32 orderHash,
        uint256 orderTakerAssetFilledAmount,
        FillResults memory fillResults
    )
        internal
    {
        // Update state
        filled[orderHash] = safeAdd(orderTakerAssetFilledAmount, fillResults.takerAssetFilledAmount);

        // Log order
        emit Fill(
            order.makerAddress,
            order.feeRecipientAddress,
            takerAddress,
            msg.sender,
            fillResults.makerAssetFilledAmount,
            fillResults.takerAssetFilledAmount,
            fillResults.makerFeePaid,
            fillResults.takerFeePaid,
            orderHash,
            order.makerAssetData,
            order.takerAssetData
        );
    }

    /// @dev Updates state with results of cancelling an order.
    ///      State is only updated if the order is currently fillable.
    ///      Otherwise, updating state would have no effect.
    /// @param order that was cancelled.
    /// @param orderHash Hash of order that was cancelled.
    function updateCancelledState(
        Order memory order,
        bytes32 orderHash
    )
        internal
    {
        // Perform cancel
        cancelled[orderHash] = true;

        // Log cancel
        emit Cancel(
            order.makerAddress,
            order.feeRecipientAddress,
            msg.sender,
            orderHash,
            order.makerAssetData,
            order.takerAssetData
        );
    }

    /// @dev Validates context for fillOrder. Succeeds or throws.
    /// @param order to be filled.
    /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
    /// @param takerAddress Address of order taker.
    /// @param takerAssetFillAmount Desired amount of order to fill by taker.
    /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
    /// @param signature Proof that the orders was created by its maker.
    function assertValidFill(
        Order memory order,
        OrderInfo memory orderInfo,
        address takerAddress,
        uint256 takerAssetFillAmount,
        uint256 takerAssetFilledAmount,
        bytes memory signature
    )
        internal
        view
    {
        // An order can only be filled if its status is FILLABLE.
        require(
            orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
            "ORDER_UNFILLABLE"
        );

        // Revert if fill amount is invalid
        require(
            takerAssetFillAmount != 0,
            "INVALID_TAKER_AMOUNT"
        );

        // Validate sender is allowed to fill this order
        if (order.senderAddress != address(0)) {
            require(
                order.senderAddress == msg.sender,
                "INVALID_SENDER"
            );
        }

        // Validate taker is allowed to fill this order
        if (order.takerAddress != address(0)) {
            require(
                order.takerAddress == takerAddress,
                "INVALID_TAKER"
            );
        }

        // Validate Maker signature (check only if first time seen)
        if (orderInfo.orderTakerAssetFilledAmount == 0) {
            require(
                isValidSignature(
                    orderInfo.orderHash,
                    order.makerAddress,
                    signature
                ),
                "INVALID_ORDER_SIGNATURE"
            );
        }

        // Validate fill order rounding
        require(
            !isRoundingError(
                takerAssetFilledAmount,
                order.takerAssetAmount,
                order.makerAssetAmount
            ),
            "ROUNDING_ERROR"
        );
    }

    /// @dev Validates context for cancelOrder. Succeeds or throws.
    /// @param order to be cancelled.
    /// @param orderInfo OrderStatus, orderHash, and amount already filled of order.
    function assertValidCancel(
        Order memory order,
        OrderInfo memory orderInfo
    )
        internal
        view
    {
        // Ensure order is valid
        // An order can only be cancelled if its status is FILLABLE.
        require(
            orderInfo.orderStatus == uint8(OrderStatus.FILLABLE),
            "ORDER_UNFILLABLE"
        );

        // Validate sender is allowed to cancel this order
        if (order.senderAddress != address(0)) {
            require(
                order.senderAddress == msg.sender,
                "INVALID_SENDER"
            );
        }

        // Validate transaction signed by maker
        address makerAddress = getCurrentContextAddress();
        require(
            order.makerAddress == makerAddress,
            "INVALID_MAKER"
        );
    }

    /// @dev Calculates amounts filled and fees paid by maker and taker.
    /// @param order to be filled.
    /// @param takerAssetFilledAmount Amount of takerAsset that will be filled.
    /// @return fillResults Amounts filled and fees paid by maker and taker.
    function calculateFillResults(
        Order memory order,
        uint256 takerAssetFilledAmount
    )
        internal
        pure
        returns (FillResults memory fillResults)
    {
        // Compute proportional transfer amounts
        fillResults.takerAssetFilledAmount = takerAssetFilledAmount;
        fillResults.makerAssetFilledAmount = getPartialAmount(
            takerAssetFilledAmount,
            order.takerAssetAmount,
            order.makerAssetAmount
        );
        fillResults.makerFeePaid = getPartialAmount(
            takerAssetFilledAmount,
            order.takerAssetAmount,
            order.makerFee
        );
        fillResults.takerFeePaid = getPartialAmount(
            takerAssetFilledAmount,
            order.takerAssetAmount,
            order.takerFee
        );

        return fillResults;
    }

    /// @dev Settles an order by transferring assets between counterparties.
    /// @param order Order struct containing order specifications.
    /// @param takerAddress Address selling takerAsset and buying makerAsset.
    /// @param fillResults Amounts to be filled and fees paid by maker and taker.
    function settleOrder(
        LibOrder.Order memory order,
        address takerAddress,
        LibFillResults.FillResults memory fillResults
    )
        private
    {
        bytes memory zrxAssetData = ZRX_ASSET_DATA;
        dispatchTransferFrom(
            order.makerAssetData,
            order.makerAddress,
            takerAddress,
            fillResults.makerAssetFilledAmount
        );
        dispatchTransferFrom(
            order.takerAssetData,
            takerAddress,
            order.makerAddress,
            fillResults.takerAssetFilledAmount
        );
        dispatchTransferFrom(
            zrxAssetData,
            order.makerAddress,
            order.feeRecipientAddress,
            fillResults.makerFeePaid
        );
        dispatchTransferFrom(
            zrxAssetData,
            takerAddress,
            order.feeRecipientAddress,
            fillResults.takerFeePaid
        );
    }
}
