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

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/IMatchOrders.sol

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


contract IMatchOrders {

    /// @dev Match two complementary orders that have a profitable spread.
    ///      Each order is filled at their respective price point. However, the calculations are
    ///      carried out as though the orders are both being filled at the right order's price point.
    ///      The profit made by the left order goes to the taker (who matched the two orders).
    /// @param leftOrder First order to match.
    /// @param rightOrder Second order to match.
    /// @param leftSignature Proof that order was created by the left maker.
    /// @param rightSignature Proof that order was created by the right maker.
    /// @return matchedFillResults Amounts filled and fees paid by maker and taker of matched orders.
    function matchOrders(
        LibOrder.Order memory leftOrder,
        LibOrder.Order memory rightOrder,
        bytes memory leftSignature,
        bytes memory rightSignature
    )
        public
        returns (LibFillResults.MatchedFillResults memory matchedFillResults);
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

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/IWrapperFunctions.sol

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


contract IWrapperFunctions {

    /// @dev Fills the input order. Reverts if exact takerAssetFillAmount not filled.
    /// @param order LibOrder.Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    function fillOrKillOrder(
        LibOrder.Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        public
        returns (LibFillResults.FillResults memory fillResults);

    /// @dev Fills an order with specified parameters and ECDSA signature.
    ///      Returns false if the transaction would otherwise revert.
    /// @param order LibOrder.Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    /// @return Amounts filled and fees paid by maker and taker.
    function fillOrderNoThrow(
        LibOrder.Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        public
        returns (LibFillResults.FillResults memory fillResults);

    /// @dev Synchronously executes multiple calls of fillOrder.
    /// @param orders Array of order specifications.
    /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
    /// @param signatures Proofs that orders have been created by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function batchFillOrders(
        LibOrder.Order[] memory orders,
        uint256[] memory takerAssetFillAmounts,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously executes multiple calls of fillOrKill.
    /// @param orders Array of order specifications.
    /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
    /// @param signatures Proofs that orders have been created by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function batchFillOrKillOrders(
        LibOrder.Order[] memory orders,
        uint256[] memory takerAssetFillAmounts,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Fills an order with specified parameters and ECDSA signature.
    ///      Returns false if the transaction would otherwise revert.
    /// @param orders Array of order specifications.
    /// @param takerAssetFillAmounts Array of desired amounts of takerAsset to sell in orders.
    /// @param signatures Proofs that orders have been created by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function batchFillOrdersNoThrow(
        LibOrder.Order[] memory orders,
        uint256[] memory takerAssetFillAmounts,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
    /// @param orders Array of order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signatures Proofs that orders have been created by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketSellOrders(
        LibOrder.Order[] memory orders,
        uint256 takerAssetFillAmount,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously executes multiple calls of fillOrder until total amount of takerAsset is sold by taker.
    ///      Returns false if the transaction would otherwise revert.
    /// @param orders Array of order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketSellOrdersNoThrow(
        LibOrder.Order[] memory orders,
        uint256 takerAssetFillAmount,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously executes multiple calls of fillOrder until total amount of makerAsset is bought by taker.
    /// @param orders Array of order specifications.
    /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketBuyOrders(
        LibOrder.Order[] memory orders,
        uint256 makerAssetFillAmount,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
    ///      Returns false if the transaction would otherwise revert.
    /// @param orders Array of order specifications.
    /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketBuyOrdersNoThrow(
        LibOrder.Order[] memory orders,
        uint256 makerAssetFillAmount,
        bytes[] memory signatures
    )
        public
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously cancels multiple orders in a single transaction.
    /// @param orders Array of order specifications.
    function batchCancelOrders(LibOrder.Order[] memory orders)
        public;

    /// @dev Fetches information for all passed in orders
    /// @param orders Array of order specifications.
    /// @return Array of OrderInfo instances that correspond to each order.
    function getOrdersInfo(LibOrder.Order[] memory orders)
        public
        view
        returns (LibOrder.OrderInfo[] memory);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/interfaces/IExchange.sol

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






// solhint-disable no-empty-blocks
contract IExchange is
    IExchangeCore,
    IMatchOrders,
    ISignatureValidator,
    ITransactions,
    IAssetProxyDispatcher,
    IWrapperFunctions
{}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/tokens/ERC20Token/IERC20Token.sol

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


contract IERC20Token {

    /// @notice send `value` token to `to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value)
        public
        returns (bool);

    /// @notice send `value` token to `to` from `from` on the condition it is approved by `from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value)
        public
        returns (bool);
    
    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value)
        public
        returns (bool);

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner)
        public view
        returns (uint256);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender)
        public view
        returns (uint256);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/tokens/EtherToken/IEtherToken.sol

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

contract IEtherToken is
    IERC20Token
{
    function deposit()
        public
        payable;
    
    function withdraw(uint256 amount)
        public;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/libs/LibConstants.sol

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



contract LibConstants {

    bytes4 constant internal ERC20_DATA_ID = bytes4(keccak256("ERC20Token(address)"));
    bytes4 constant internal ERC721_DATA_ID = bytes4(keccak256("ERC721Token(address,uint256)"));
    uint256 constant internal MAX_UINT = 2**256 - 1;
    uint256 constant internal PERCENTAGE_DENOMINATOR = 10**18; 
    uint256 constant internal MAX_FEE_PERCENTAGE = 5 * PERCENTAGE_DENOMINATOR / 100;         // 5%
    uint256 constant internal MAX_WETH_FILL_PERCENTAGE = 95 * PERCENTAGE_DENOMINATOR / 100;  // 95%
 
     // solhint-disable var-name-mixedcase
    IExchange internal EXCHANGE;
    IEtherToken internal ETHER_TOKEN;
    IERC20Token internal ZRX_TOKEN;
    bytes internal ZRX_ASSET_DATA;
    bytes internal WETH_ASSET_DATA;
    // solhint-enable var-name-mixedcase

    constructor (
        address _exchange,
        address _etherToken,
        address _zrxToken,
        bytes memory _zrxAssetData,
        bytes memory _wethAssetData
    )
        public
    {
        EXCHANGE = IExchange(_exchange);
        ETHER_TOKEN = IEtherToken(_etherToken);
        ZRX_TOKEN = IERC20Token(_zrxToken);
        ZRX_ASSET_DATA = _zrxAssetData;
        WETH_ASSET_DATA = _wethAssetData;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/mixins/MWeth.sol

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


contract MWeth {

    /// @dev Converts message call's ETH value into WETH.
    function convertEthToWeth()
        internal;

    /// @dev Transfers feePercentage of WETH spent on primary orders to feeRecipient.
    ///      Refunds any excess ETH to msg.sender.
    /// @param wethSoldExcludingFeeOrders Amount of WETH sold when filling primary orders.
    /// @param wethSoldForZrx Amount of WETH sold when purchasing ZRX required for primary order fees.
    /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
    /// @param feeRecipient Address that will receive ETH when orders are filled.
    function transferEthFeeAndRefund(
        uint256 wethSoldExcludingFeeOrders,
        uint256 wethSoldForZrx,
        uint256 feePercentage,
        address feeRecipient
    )
        internal;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/MixinWeth.sol

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



contract MixinWeth is
    LibMath,
    LibConstants,
    MWeth
{

    /// @dev Default payabale function, this allows us to withdraw WETH
    function ()
        public
        payable
    {
        require(
            msg.sender == address(ETHER_TOKEN),
            "DEFAULT_FUNCTION_WETH_CONTRACT_ONLY"
        );
    }

    /// @dev Converts message call's ETH value into WETH.
    function convertEthToWeth()
        internal
    {
        require(
            msg.value > 0,
            "INVALID_MSG_VALUE"
        );
        ETHER_TOKEN.deposit.value(msg.value)();
    }

    /// @dev Transfers feePercentage of WETH spent on primary orders to feeRecipient.
    ///      Refunds any excess ETH to msg.sender.
    /// @param wethSoldExcludingFeeOrders Amount of WETH sold when filling primary orders.
    /// @param wethSoldForZrx Amount of WETH sold when purchasing ZRX required for primary order fees.
    /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
    /// @param feeRecipient Address that will receive ETH when orders are filled.
    function transferEthFeeAndRefund(
        uint256 wethSoldExcludingFeeOrders,
        uint256 wethSoldForZrx,
        uint256 feePercentage,
        address feeRecipient
    )
        internal
    {
        // Ensure feePercentage is less than 5%.
        require(
            feePercentage <= MAX_FEE_PERCENTAGE,
            "FEE_PERCENTAGE_TOO_LARGE"
        );

        // Calculate amount of WETH that hasn't been sold.
        uint256 wethRemaining = safeSub(
            msg.value,
            safeAdd(wethSoldExcludingFeeOrders, wethSoldForZrx)
        );

        // Calculate ETH fee to pay to feeRecipient.
        uint256 ethFee = getPartialAmount(
            feePercentage,
            PERCENTAGE_DENOMINATOR,
            wethSoldExcludingFeeOrders
        );

        // Ensure fee is less than amount of WETH remaining.
        require(
            ethFee <= wethRemaining,
            "INSUFFICIENT_ETH_REMAINING"
        );
    
        // Do nothing if no WETH remaining
        if (wethRemaining > 0) {
            // Convert remaining WETH to ETH
            ETHER_TOKEN.withdraw(wethRemaining);

            // Pay ETH to feeRecipient
            if (ethFee > 0) {
                feeRecipient.transfer(ethFee);
            }

            // Refund remaining ETH to msg.sender.
            uint256 ethRefund = safeSub(wethRemaining, ethFee);
            if (ethRefund > 0) {
                msg.sender.transfer(ethRefund);
            }
        }
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/interfaces/IAssets.sol

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


contract IAssets {

    /// @dev Withdraws ERC20 tokens from this contract. The contract requires a ZRX balance in order to 
    ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
    ///      used to withdraw tokens that were accidentally sent to this contract.
    /// @param token Address of ERC20 token to withdraw.
    /// @param amount Amount of ERC20 token to withdraw.
    function withdrawERC20(
        address token,
        uint256 amount
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/mixins/MAssets.sol

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

contract MAssets is
    IAssets
{

    /// @dev Transfers given amount of asset to sender.
    /// @param assetData Byte array encoded for the respective asset proxy.
    /// @param amount Amount of asset to transfer to sender.
    function transferPurchasedAssetToSender(
        bytes memory assetData,
        uint256 amount
    )
        internal;

    /// @dev Decodes ERC20 assetData and transfers given amount to sender.
    /// @param assetData Byte array encoded for the respective asset proxy.
    /// @param amount Amount of asset to transfer to sender.
    function transferERC20Token(
        bytes memory assetData,
        uint256 amount
    )
        internal;

    /// @dev Decodes ERC721 assetData and transfers given amount to sender.
    /// @param assetData Byte array encoded for the respective asset proxy.
    /// @param amount Amount of asset to transfer to sender.
    function transferERC721Token(
        bytes memory assetData,
        uint256 amount
    )
        internal;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/mixins/MExchangeWrapper.sol

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


contract MExchangeWrapper {

    /// @dev Fills the input order.
    ///      Returns false if the transaction would otherwise revert.
    /// @param order Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    /// @return Amounts filled and fees paid by maker and taker.
    function fillOrderNoThrow(
        LibOrder.Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        internal
        returns (LibFillResults.FillResults memory fillResults);

    /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
    ///      Returns false if the transaction would otherwise revert.
    /// @param orders Array of order specifications.
    /// @param wethSellAmount Desired amount of WETH to sell.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketSellWeth(
        LibOrder.Order[] memory orders,
        uint256 wethSellAmount,
        bytes[] memory signatures
    )
        internal
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
    ///      Returns false if the transaction would otherwise revert.
    ///      The asset being sold by taker must always be WETH.
    /// @param orders Array of order specifications.
    /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketBuyWithWeth(
        LibOrder.Order[] memory orders,
        uint256 makerAssetFillAmount,
        bytes[] memory signatures
    )
        internal
        returns (LibFillResults.FillResults memory totalFillResults);

    /// @dev Buys zrxBuyAmount of ZRX fee tokens, taking into account ZRX fees for each order. This will guarantee
    ///      that at least zrxBuyAmount of ZRX is purchased (sometimes slightly over due to rounding issues).
    ///      It is possible that a request to buy 200 ZRX will require purchasing 202 ZRX
    ///      as 2 ZRX is required to purchase the 200 ZRX fee tokens. This guarantees at least 200 ZRX for future purchases.
    ///      The asset being sold by taker must always be WETH. 
    /// @param orders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset.
    /// @param zrxBuyAmount Desired amount of ZRX to buy.
    /// @param signatures Proofs that orders have been created by makers.
    /// @return totalFillResults Amounts filled and fees paid by maker and taker.
    function marketBuyZrxWithWeth(
        LibOrder.Order[] memory orders,
        uint256 zrxBuyAmount,
        bytes[] memory signatures
    )
        internal
        returns (LibFillResults.FillResults memory totalFillResults);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/interfaces/IForwarderCore.sol

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


contract IForwarderCore {

    /// @dev Purchases as much of orders' makerAssets as possible by selling up to 95% of transaction's ETH value.
    ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
    ///      5% of ETH value is reserved for paying fees to order feeRecipients (in ZRX) and forwarding contract feeRecipient (in ETH).
    ///      Any ETH not spent will be refunded to sender.
    /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
    /// @param signatures Proofs that orders have been created by makers.
    /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
    /// @param feeSignatures Proofs that feeOrders have been created by makers.
    /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
    /// @param feeRecipient Address that will receive ETH when orders are filled.
    /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
    function marketSellOrdersWithEth(
        LibOrder.Order[] memory orders,
        bytes[] memory signatures,
        LibOrder.Order[] memory feeOrders,
        bytes[] memory feeSignatures,
        uint256  feePercentage,
        address feeRecipient
    )
        public
        payable
        returns (
            LibFillResults.FillResults memory orderFillResults,
            LibFillResults.FillResults memory feeOrderFillResults
        );

    /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
    ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
    ///      Any ETH not spent will be refunded to sender.
    /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
    /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
    /// @param signatures Proofs that orders have been created by makers.
    /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
    /// @param feeSignatures Proofs that feeOrders have been created by makers.
    /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
    /// @param feeRecipient Address that will receive ETH when orders are filled.
    /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
    function marketBuyOrdersWithEth(
        LibOrder.Order[] memory orders,
        uint256 makerAssetFillAmount,
        bytes[] memory signatures,
        LibOrder.Order[] memory feeOrders,
        bytes[] memory feeSignatures,
        uint256  feePercentage,
        address feeRecipient
    )
        public
        payable
        returns (
            LibFillResults.FillResults memory orderFillResults,
            LibFillResults.FillResults memory feeOrderFillResults
        );
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/mixins/MForwarderCore.sol

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



contract MForwarderCore is
    IForwarderCore
{

    /// @dev Ensures that all ZRX fees have been repurchased and no extra WETH owned by this contract has been sold.
    /// @param orderFillResults Amounts filled and fees paid for primary orders.
    /// @param feeOrderFillResults Amounts filled and fees paid for fee orders.
    /// @param zrxBuyAmount The amount of ZRX that needed to be repurchased after filling primary orders.
    function assertValidFillResults(
        LibFillResults.FillResults memory orderFillResults,
        LibFillResults.FillResults memory feeOrderFillResults,
        uint256 zrxBuyAmount
    )
        internal
        view;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/utils/LibBytes/LibBytes.sol

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


library LibBytes {

    using LibBytes for bytes;

    /// @dev Gets the memory address for a byte array.
    /// @param input Byte array to lookup.
    /// @return memoryAddress Memory address of byte array. This
    ///         points to the header of the byte array which contains
    ///         the length.
    function rawAddress(bytes memory input)
        internal
        pure
        returns (uint256 memoryAddress)
    {
        assembly {
            memoryAddress := input
        }
        return memoryAddress;
    }
    
    /// @dev Gets the memory address for the contents of a byte array.
    /// @param input Byte array to lookup.
    /// @return memoryAddress Memory address of the contents of the byte array.
    function contentAddress(bytes memory input)
        internal
        pure
        returns (uint256 memoryAddress)
    {
        assembly {
            memoryAddress := add(input, 32)
        }
        return memoryAddress;
    }

    /// @dev Copies `length` bytes from memory location `source` to `dest`.
    /// @param dest memory address to copy bytes to.
    /// @param source memory address to copy bytes from.
    /// @param length number of bytes to copy.
    function memCopy(
        uint256 dest,
        uint256 source,
        uint256 length
    )
        internal
        pure
    {
        if (length < 32) {
            // Handle a partial word by reading destination and masking
            // off the bits we are interested in.
            // This correctly handles overlap, zero lengths and source == dest
            assembly {
                let mask := sub(exp(256, sub(32, length)), 1)
                let s := and(mload(source), not(mask))
                let d := and(mload(dest), mask)
                mstore(dest, or(s, d))
            }
        } else {
            // Skip the O(length) loop when source == dest.
            if (source == dest) {
                return;
            }

            // For large copies we copy whole words at a time. The final
            // word is aligned to the end of the range (instead of after the
            // previous) to handle partial words. So a copy will look like this:
            //
            //  ####
            //      ####
            //          ####
            //            ####
            //
            // We handle overlap in the source and destination range by
            // changing the copying direction. This prevents us from
            // overwriting parts of source that we still need to copy.
            //
            // This correctly handles source == dest
            //
            if (source > dest) {
                assembly {
                    // We subtract 32 from `sEnd` and `dEnd` because it
                    // is easier to compare with in the loop, and these
                    // are also the addresses we need for copying the
                    // last bytes.
                    length := sub(length, 32)
                    let sEnd := add(source, length)
                    let dEnd := add(dest, length)

                    // Remember the last 32 bytes of source
                    // This needs to be done here and not after the loop
                    // because we may have overwritten the last bytes in
                    // source already due to overlap.
                    let last := mload(sEnd)

                    // Copy whole words front to back
                    // Note: the first check is always true,
                    // this could have been a do-while loop.
                    // solhint-disable-next-line no-empty-blocks
                    for {} lt(source, sEnd) {} {
                        mstore(dest, mload(source))
                        source := add(source, 32)
                        dest := add(dest, 32)
                    }
                    
                    // Write the last 32 bytes
                    mstore(dEnd, last)
                }
            } else {
                assembly {
                    // We subtract 32 from `sEnd` and `dEnd` because those
                    // are the starting points when copying a word at the end.
                    length := sub(length, 32)
                    let sEnd := add(source, length)
                    let dEnd := add(dest, length)

                    // Remember the first 32 bytes of source
                    // This needs to be done here and not after the loop
                    // because we may have overwritten the first bytes in
                    // source already due to overlap.
                    let first := mload(source)

                    // Copy whole words back to front
                    // We use a signed comparisson here to allow dEnd to become
                    // negative (happens when source and dest < 32). Valid
                    // addresses in local memory will never be larger than
                    // 2**255, so they can be safely re-interpreted as signed.
                    // Note: the first check is always true,
                    // this could have been a do-while loop.
                    // solhint-disable-next-line no-empty-blocks
                    for {} slt(dest, dEnd) {} {
                        mstore(dEnd, mload(sEnd))
                        sEnd := sub(sEnd, 32)
                        dEnd := sub(dEnd, 32)
                    }
                    
                    // Write the first 32 bytes
                    mstore(dest, first)
                }
            }
        }
    }

    /// @dev Returns a slices from a byte array.
    /// @param b The byte array to take a slice from.
    /// @param from The starting index for the slice (inclusive).
    /// @param to The final index for the slice (exclusive).
    /// @return result The slice containing bytes at indices [from, to)
    function slice(
        bytes memory b,
        uint256 from,
        uint256 to
    )
        internal
        pure
        returns (bytes memory result)
    {
        require(
            from <= to,
            "FROM_LESS_THAN_TO_REQUIRED"
        );
        require(
            to < b.length,
            "TO_LESS_THAN_LENGTH_REQUIRED"
        );
        
        // Create a new bytes structure and copy contents
        result = new bytes(to - from);
        memCopy(
            result.contentAddress(),
            b.contentAddress() + from,
            result.length);
        return result;
    }
    
    /// @dev Returns a slice from a byte array without preserving the input.
    /// @param b The byte array to take a slice from. Will be destroyed in the process.
    /// @param from The starting index for the slice (inclusive).
    /// @param to The final index for the slice (exclusive).
    /// @return result The slice containing bytes at indices [from, to)
    /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
    function sliceDestructive(
        bytes memory b,
        uint256 from,
        uint256 to
    )
        internal
        pure
        returns (bytes memory result)
    {
        require(
            from <= to,
            "FROM_LESS_THAN_TO_REQUIRED"
        );
        require(
            to < b.length,
            "TO_LESS_THAN_LENGTH_REQUIRED"
        );
        
        // Create a new bytes structure around [from, to) in-place.
        assembly {
            result := add(b, from)
            mstore(result, sub(to, from))
        }
        return result;
    }

    /// @dev Pops the last byte off of a byte array by modifying its length.
    /// @param b Byte array that will be modified.
    /// @return The byte that was popped off.
    function popLastByte(bytes memory b)
        internal
        pure
        returns (bytes1 result)
    {
        require(
            b.length > 0,
            "GREATER_THAN_ZERO_LENGTH_REQUIRED"
        );

        // Store last byte.
        result = b[b.length - 1];

        assembly {
            // Decrement length of byte array.
            let newLen := sub(mload(b), 1)
            mstore(b, newLen)
        }
        return result;
    }

    /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
    /// @param b Byte array that will be modified.
    /// @return The 20 byte address that was popped off.
    function popLast20Bytes(bytes memory b)
        internal
        pure
        returns (address result)
    {
        require(
            b.length >= 20,
            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
        );

        // Store last 20 bytes.
        result = readAddress(b, b.length - 20);

        assembly {
            // Subtract 20 from byte array length.
            let newLen := sub(mload(b), 20)
            mstore(b, newLen)
        }
        return result;
    }

    /// @dev Tests equality of two byte arrays.
    /// @param lhs First byte array to compare.
    /// @param rhs Second byte array to compare.
    /// @return True if arrays are the same. False otherwise.
    function equals(
        bytes memory lhs,
        bytes memory rhs
    )
        internal
        pure
        returns (bool equal)
    {
        // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
        // We early exit on unequal lengths, but keccak would also correctly
        // handle this.
        return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
    }

    /// @dev Reads an address from a position in a byte array.
    /// @param b Byte array containing an address.
    /// @param index Index in byte array of address.
    /// @return address from byte array.
    function readAddress(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (address result)
    {
        require(
            b.length >= index + 20,  // 20 is length of address
            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
        );

        // Add offset to index:
        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
        index += 20;

        // Read address from array memory
        assembly {
            // 1. Add index to address of bytes array
            // 2. Load 32-byte word from memory
            // 3. Apply 20-byte mask to obtain address
            result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
        }
        return result;
    }

    /// @dev Writes an address into a specific position in a byte array.
    /// @param b Byte array to insert address into.
    /// @param index Index in byte array of address.
    /// @param input Address to put into byte array.
    function writeAddress(
        bytes memory b,
        uint256 index,
        address input
    )
        internal
        pure
    {
        require(
            b.length >= index + 20,  // 20 is length of address
            "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
        );

        // Add offset to index:
        // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
        // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
        index += 20;

        // Store address into array memory
        assembly {
            // The address occupies 20 bytes and mstore stores 32 bytes.
            // First fetch the 32-byte word where we'll be storing the address, then
            // apply a mask so we have only the bytes in the word that the address will not occupy.
            // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.

            // 1. Add index to address of bytes array
            // 2. Load 32-byte word from memory
            // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
            let neighbors := and(
                mload(add(b, index)),
                0xffffffffffffffffffffffff0000000000000000000000000000000000000000
            )
            
            // Make sure input address is clean.
            // (Solidity does not guarantee this)
            input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)

            // Store the neighbors and address into memory
            mstore(add(b, index), xor(input, neighbors))
        }
    }

    /// @dev Reads a bytes32 value from a position in a byte array.
    /// @param b Byte array containing a bytes32 value.
    /// @param index Index in byte array of bytes32 value.
    /// @return bytes32 value from byte array.
    function readBytes32(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (bytes32 result)
    {
        require(
            b.length >= index + 32,
            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
        );

        // Arrays are prefixed by a 256 bit length parameter
        index += 32;

        // Read the bytes32 from array memory
        assembly {
            result := mload(add(b, index))
        }
        return result;
    }

    /// @dev Writes a bytes32 into a specific position in a byte array.
    /// @param b Byte array to insert <input> into.
    /// @param index Index in byte array of <input>.
    /// @param input bytes32 to put into byte array.
    function writeBytes32(
        bytes memory b,
        uint256 index,
        bytes32 input
    )
        internal
        pure
    {
        require(
            b.length >= index + 32,
            "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
        );

        // Arrays are prefixed by a 256 bit length parameter
        index += 32;

        // Read the bytes32 from array memory
        assembly {
            mstore(add(b, index), input)
        }
    }

    /// @dev Reads a uint256 value from a position in a byte array.
    /// @param b Byte array containing a uint256 value.
    /// @param index Index in byte array of uint256 value.
    /// @return uint256 value from byte array.
    function readUint256(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (uint256 result)
    {
        return uint256(readBytes32(b, index));
    }

    /// @dev Writes a uint256 into a specific position in a byte array.
    /// @param b Byte array to insert <input> into.
    /// @param index Index in byte array of <input>.
    /// @param input uint256 to put into byte array.
    function writeUint256(
        bytes memory b,
        uint256 index,
        uint256 input
    )
        internal
        pure
    {
        writeBytes32(b, index, bytes32(input));
    }

    /// @dev Reads an unpadded bytes4 value from a position in a byte array.
    /// @param b Byte array containing a bytes4 value.
    /// @param index Index in byte array of bytes4 value.
    /// @return bytes4 value from byte array.
    function readBytes4(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (bytes4 result)
    {
        require(
            b.length >= index + 4,
            "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
        );
        assembly {
            result := mload(add(b, 32))
            // Solidity does not require us to clean the trailing bytes.
            // We do it anyway
            result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
        }
        return result;
    }

    /// @dev Reads nested bytes from a specific position.
    /// @dev NOTE: the returned value overlaps with the input value.
    ///            Both should be treated as immutable.
    /// @param b Byte array containing nested bytes.
    /// @param index Index of nested bytes.
    /// @return result Nested bytes.
    function readBytesWithLength(
        bytes memory b,
        uint256 index
    )
        internal
        pure
        returns (bytes memory result)
    {
        // Read length of nested bytes
        uint256 nestedBytesLength = readUint256(b, index);
        index += 32;

        // Assert length of <b> is valid, given
        // length of nested bytes
        require(
            b.length >= index + nestedBytesLength,
            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
        );
        
        // Return a pointer to the byte array as it exists inside `b`
        assembly {
            result := add(b, index)
        }
        return result;
    }

    /// @dev Inserts bytes at a specific position in a byte array.
    /// @param b Byte array to insert <input> into.
    /// @param index Index in byte array of <input>.
    /// @param input bytes to insert.
    function writeBytesWithLength(
        bytes memory b,
        uint256 index,
        bytes memory input
    )
        internal
        pure
    {
        // Assert length of <b> is valid, given
        // length of input
        require(
            b.length >= index + 32 + input.length,  // 32 bytes to store length
            "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
        );

        // Copy <input> into <b>
        memCopy(
            b.contentAddress() + index,
            input.rawAddress(), // includes length of <input>
            input.length + 32   // +32 bytes to store <input> length
        );
    }

    /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
    /// @param dest Byte array that will be overwritten with source bytes.
    /// @param source Byte array to copy onto dest bytes.
    function deepCopyBytes(
        bytes memory dest,
        bytes memory source
    )
        internal
        pure
    {
        uint256 sourceLen = source.length;
        // Dest length must be >= source length, or some bytes would not be copied.
        require(
            dest.length >= sourceLen,
            "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
        );
        memCopy(
            dest.contentAddress(),
            source.contentAddress(),
            sourceLen
        );
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/MixinForwarderCore.sol

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









contract MixinForwarderCore is
    LibFillResults,
    LibMath,
    LibConstants,
    MWeth,
    MAssets,
    MExchangeWrapper,
    MForwarderCore
{

    using LibBytes for bytes;

    /// @dev Constructor approves ERC20 proxy to transfer ZRX and WETH on this contract's behalf.
    constructor ()
        public
    {
        address proxyAddress = EXCHANGE.getAssetProxy(ERC20_DATA_ID);
        if (proxyAddress != address(0)) {
            ETHER_TOKEN.approve(proxyAddress, MAX_UINT);
            ZRX_TOKEN.approve(proxyAddress, MAX_UINT);
        }
    }

    /// @dev Purchases as much of orders' makerAssets as possible by selling up to 95% of transaction's ETH value.
    ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
    ///      5% of ETH value is reserved for paying fees to order feeRecipients (in ZRX) and forwarding contract feeRecipient (in ETH).
    ///      Any ETH not spent will be refunded to sender.
    /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
    /// @param signatures Proofs that orders have been created by makers.
    /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
    /// @param feeSignatures Proofs that feeOrders have been created by makers.
    /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
    /// @param feeRecipient Address that will receive ETH when orders are filled.
    /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
    function marketSellOrdersWithEth(
        LibOrder.Order[] memory orders,
        bytes[] memory signatures,
        LibOrder.Order[] memory feeOrders,
        bytes[] memory feeSignatures,
        uint256  feePercentage,
        address feeRecipient
    )
        public
        payable
        returns (
            FillResults memory orderFillResults,
            FillResults memory feeOrderFillResults
        )
    {
        // Convert ETH to WETH.
        convertEthToWeth();

        uint256 wethSellAmount;
        uint256 zrxBuyAmount;
        uint256 makerAssetAmountPurchased;
        if (orders[0].makerAssetData.equals(ZRX_ASSET_DATA)) {
            // Calculate amount of WETH that won't be spent on ETH fees.
            wethSellAmount = getPartialAmount(
                PERCENTAGE_DENOMINATOR,
                safeAdd(PERCENTAGE_DENOMINATOR, feePercentage),
                msg.value
            );
            // Market sell available WETH.
            // ZRX fees are paid with this contract's balance.
            orderFillResults = marketSellWeth(
                orders,
                wethSellAmount,
                signatures
            );
            // The fee amount must be deducted from the amount transfered back to sender.
            makerAssetAmountPurchased = safeSub(orderFillResults.makerAssetFilledAmount, orderFillResults.takerFeePaid);
        } else {
            // 5% of WETH is reserved for filling feeOrders and paying feeRecipient.
            wethSellAmount = getPartialAmount(
                MAX_WETH_FILL_PERCENTAGE,
                PERCENTAGE_DENOMINATOR,
                msg.value
            );
            // Market sell 95% of WETH.
            // ZRX fees are payed with this contract's balance.
            orderFillResults = marketSellWeth(
                orders,
                wethSellAmount,
                signatures
            );
            // Buy back all ZRX spent on fees.
            zrxBuyAmount = orderFillResults.takerFeePaid;
            feeOrderFillResults = marketBuyZrxWithWeth(
                feeOrders,
                zrxBuyAmount,
                feeSignatures
            );
            makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
        }

        // Ensure that all ZRX fees have been repurchased and no extra WETH owned by this contract has been sold.
        assertValidFillResults(
            orderFillResults,
            feeOrderFillResults,
            zrxBuyAmount
        );

        // Transfer feePercentage of total ETH spent on primary orders to feeRecipient.
        // Refund remaining ETH to msg.sender.
        transferEthFeeAndRefund(
            orderFillResults.takerAssetFilledAmount,
            feeOrderFillResults.takerAssetFilledAmount,
            feePercentage,
            feeRecipient
        );

        // Transfer purchased assets to msg.sender.
        transferPurchasedAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
    }

    /// @dev Attempt to purchase makerAssetFillAmount of makerAsset by selling ETH provided with transaction.
    ///      Any ZRX required to pay fees for primary orders will automatically be purchased by this contract.
    ///      Any ETH not spent will be refunded to sender.
    /// @param orders Array of order specifications used containing desired makerAsset and WETH as takerAsset. 
    /// @param makerAssetFillAmount Desired amount of makerAsset to purchase.
    /// @param signatures Proofs that orders have been created by makers.
    /// @param feeOrders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset. Used to purchase ZRX for primary order fees.
    /// @param feeSignatures Proofs that feeOrders have been created by makers.
    /// @param feePercentage Percentage of WETH sold that will payed as fee to forwarding contract feeRecipient.
    /// @param feeRecipient Address that will receive ETH when orders are filled.
    /// @return Amounts filled and fees paid by maker and taker for both sets of orders.
    function marketBuyOrdersWithEth(
        LibOrder.Order[] memory orders,
        uint256 makerAssetFillAmount,
        bytes[] memory signatures,
        LibOrder.Order[] memory feeOrders,
        bytes[] memory feeSignatures,
        uint256  feePercentage,
        address feeRecipient
    )
        public
        payable
        returns (
            FillResults memory orderFillResults,
            FillResults memory feeOrderFillResults
        )
    {
        // Convert ETH to WETH.
        convertEthToWeth();

        uint256 zrxBuyAmount;
        uint256 makerAssetAmountPurchased;
        if (orders[0].makerAssetData.equals(ZRX_ASSET_DATA)) {
            // If the makerAsset is ZRX, it is not necessary to pay fees out of this
            // contracts's ZRX balance because fees are factored into the price of the order.
            orderFillResults = marketBuyZrxWithWeth(
                orders,
                makerAssetFillAmount,
                signatures
            );
            // The fee amount must be deducted from the amount transfered back to sender.
            makerAssetAmountPurchased = safeSub(orderFillResults.makerAssetFilledAmount, orderFillResults.takerFeePaid);
        } else {
            // Attemp to purchase desired amount of makerAsset.
            // ZRX fees are payed with this contract's balance.
            orderFillResults = marketBuyWithWeth(
                orders,
                makerAssetFillAmount,
                signatures
            );
            // Buy back all ZRX spent on fees.
            zrxBuyAmount = orderFillResults.takerFeePaid;
            feeOrderFillResults = marketBuyZrxWithWeth(
                feeOrders,
                zrxBuyAmount,
                feeSignatures
            );
            makerAssetAmountPurchased = orderFillResults.makerAssetFilledAmount;
        }

        // Ensure that all ZRX fees have been repurchased and no extra WETH owned by this contract has been sold.
        assertValidFillResults(
            orderFillResults,
            feeOrderFillResults,
            zrxBuyAmount
        );

        // Transfer feePercentage of total ETH spent on primary orders to feeRecipient.
        // Refund remaining ETH to msg.sender.
        transferEthFeeAndRefund(
            orderFillResults.takerAssetFilledAmount,
            feeOrderFillResults.takerAssetFilledAmount,
            feePercentage,
            feeRecipient
        );

        // Transfer purchased assets to msg.sender.
        transferPurchasedAssetToSender(orders[0].makerAssetData, makerAssetAmountPurchased);
    }

    /// @dev Ensures that all ZRX fees have been repurchased and no extra WETH owned by this contract has been sold.
    /// @param orderFillResults Amounts filled and fees paid for primary orders.
    /// @param feeOrderFillResults Amounts filled and fees paid for fee orders.
    /// @param zrxBuyAmount The amount of ZRX that needed to be repurchased after filling primary orders.
    function assertValidFillResults(
        FillResults memory orderFillResults,
        FillResults memory feeOrderFillResults,
        uint256 zrxBuyAmount
    )
        internal
        view
    {
        // Ensure that all ZRX spent while filling primary orders has been repurchased.
        uint256 zrxPurchased = safeSub(feeOrderFillResults.makerAssetFilledAmount, feeOrderFillResults.takerFeePaid);
        require(
            zrxPurchased >= zrxBuyAmount,
            "COMPLETE_FILL_FAILED"
        );

        // Ensure that no extra WETH owned by this contract has been sold.
        uint256 wethSold = safeAdd(orderFillResults.takerAssetFilledAmount, feeOrderFillResults.takerAssetFilledAmount);
        require(
            wethSold <= msg.value,
            "OVERSOLD_WETH"
        );
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/utils/Ownable/IOwnable.sol

pragma solidity 0.4.24;

/*
 * Ownable
 *
 * Base contract with an owner.
 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
 */

contract IOwnable {
    function transferOwnership(address newOwner)
        public;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/utils/Ownable/Ownable.sol

pragma solidity 0.4.24;

/*
 * Ownable
 *
 * Base contract with an owner.
 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
 */

contract Ownable is IOwnable {
    address public owner;

    constructor ()
        public
    {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "ONLY_CONTRACT_OWNER"
        );
        _;
    }

    function transferOwnership(address newOwner)
        public
        onlyOwner
    {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/tokens/ERC721Token/IERC721Token.sol

/*
The MIT License (MIT)

Copyright (c) 2016 Smart Contract Solutions, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

pragma solidity 0.4.24;


/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 * Modified from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC721/ERC721Basic.sol
 */
contract IERC721Token {
    string internal name_;
    string internal symbol_;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _tokenId
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 _tokenId
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    function name()
        public
        view
        returns (string);

    function symbol()
        public
        view
        returns (string);

    function balanceOf(address _owner)
        public
        view
        returns (uint256 _balance);

    function ownerOf(uint256 _tokenId)
        public
        view
        returns (address _owner);

    function exists(uint256 _tokenId)
        public
        view
        returns (bool _exists);

    function approve(address _to, uint256 _tokenId)
        public;

    function getApproved(uint256 _tokenId)
        public
        view
        returns (address _operator);

    function setApprovalForAll(address _operator, bool _approved)
        public;

    function isApprovedForAll(address _owner, address _operator)
        public
        view
        returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        public;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        public;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes _data
    )
        public;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/MixinAssets.sol

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






contract MixinAssets is
    Ownable,
    LibConstants,
    MAssets
{

    using LibBytes for bytes;

    bytes4 constant internal ERC20_TRANSFER_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));

    /// @dev Withdraws ERC20 tokens from this contract. The contract requires a ZRX balance in order to 
    ///      function optimally, and this function allows the ZRX to be withdrawn by owner. It may also be
    ///      used to withdraw tokens that were accidentally sent to this contract.
    /// @param token Address of ERC20 token to withdraw.
    /// @param amount Amount of ERC20 token to withdraw.
    function withdrawERC20(
        address token,
        uint256 amount
    )
        external
        onlyOwner
    {
        require(
            IERC20Token(token).transfer(msg.sender, amount),
            "WITHDRAWAL_FAILED"
        );
    }

    /// @dev Transfers given amount of asset to sender.
    /// @param assetData Byte array encoded for the respective asset proxy.
    /// @param amount Amount of asset to transfer to sender.
    function transferPurchasedAssetToSender(
        bytes memory assetData,
        uint256 amount
    )
        internal
    {
        bytes4 proxyId = assetData.readBytes4(0);

        if (proxyId == ERC20_DATA_ID) {
            transferERC20Token(assetData, amount);
        } else if (proxyId == ERC721_DATA_ID) {
            transferERC721Token(assetData, amount);
        } else {
            revert("UNSUPPORTED_TOKEN_PROXY");
        }
    }

    /// @dev Decodes ERC20 assetData and transfers given amount to sender.
    /// @param assetData Byte array encoded for the respective asset proxy.
    /// @param amount Amount of asset to transfer to sender.
    function transferERC20Token(
        bytes memory assetData,
        uint256 amount
    )
        internal
    {
        address token = assetData.readAddress(16);

        // Transfer tokens.
        // We do a raw call so we can check the success separate
        // from the return data.
        bool success = token.call(abi.encodeWithSelector(
            ERC20_TRANSFER_SELECTOR,
            msg.sender,
            amount
        ));
        require(
            success,
            "TRANSFER_FAILED"
        );
        
        // Check return data.
        // If there is no return data, we assume the token incorrectly
        // does not return a bool. In this case we expect it to revert
        // on failure, which was handled above.
        // If the token does return data, we require that it is a single
        // value that evaluates to true.
        assembly {
            if returndatasize {
                success := 0
                if eq(returndatasize, 32) {
                    // First 64 bytes of memory are reserved scratch space
                    returndatacopy(0, 0, 32)
                    success := mload(0)
                }
            }
        }
        require(
            success,
            "TRANSFER_FAILED"
        );
    }

    /// @dev Decodes ERC721 assetData and transfers given amount to sender.
    /// @param assetData Byte array encoded for the respective asset proxy.
    /// @param amount Amount of asset to transfer to sender.
    function transferERC721Token(
        bytes memory assetData,
        uint256 amount
    )
        internal
    {
        require(
            amount == 1,
            "INVALID_AMOUNT"
        );
        // Decode asset data.
        address token = assetData.readAddress(16);
        uint256 tokenId = assetData.readUint256(36);

        // Perform transfer.
        IERC721Token(token).transferFrom(
            address(this),
            msg.sender,
            tokenId
        );
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/protocol/Exchange/libs/LibAbiEncoder.sol

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

contract LibAbiEncoder {

    /// @dev ABI encodes calldata for `fillOrder` in memory and returns the address range.
    ///      This range can be passed into `call` or `delegatecall` to invoke an external
    ///      call to `fillOrder`.
    /// @param order Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    /// @return calldataBegin Memory address of ABI encoded calldata.
    /// @return calldataLength Lenfgth of ABI encoded calldata.
    function abiEncodeFillOrder(
        LibOrder.Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        public
        pure
        returns (bytes memory fillOrderCalldata)
    {
        // We need to call MExchangeCore.fillOrder using a delegatecall in
        // assembly so that we can intercept a call that throws. For this, we
        // need the input encoded in memory in the Ethereum ABIv2 format [1].

        // | Area     | Offset | Length  | Contents                                    |
        // | -------- |--------|---------|-------------------------------------------- |
        // | Header   | 0x00   | 4       | function selector                           |
        // | Params   |        | 3 * 32  | function parameters:                        |
        // |          | 0x00   |         |   1. offset to order (*)                    |
        // |          | 0x20   |         |   2. takerAssetFillAmount                   |
        // |          | 0x40   |         |   3. offset to signature (*)                |
        // | Data     |        | 12 * 32 | order:                                      |
        // |          | 0x000  |         |   1.  senderAddress                         |
        // |          | 0x020  |         |   2.  makerAddress                          |
        // |          | 0x040  |         |   3.  takerAddress                          |
        // |          | 0x060  |         |   4.  feeRecipientAddress                   |
        // |          | 0x080  |         |   5.  makerAssetAmount                      |
        // |          | 0x0A0  |         |   6.  takerAssetAmount                      |
        // |          | 0x0C0  |         |   7.  makerFeeAmount                        |
        // |          | 0x0E0  |         |   8.  takerFeeAmount                        |
        // |          | 0x100  |         |   9.  expirationTimeSeconds                 |
        // |          | 0x120  |         |   10. salt                                  |
        // |          | 0x140  |         |   11. Offset to makerAssetData (*)          |
        // |          | 0x160  |         |   12. Offset to takerAssetData (*)          |
        // |          | 0x180  | 32      | makerAssetData Length                       |
        // |          | 0x1A0  | **      | makerAssetData Contents                     |
        // |          | 0x1C0  | 32      | takerAssetData Length                       |
        // |          | 0x1E0  | **      | takerAssetData Contents                     |
        // |          | 0x200  | 32      | signature Length                            |
        // |          | 0x220  | **      | signature Contents                          |

        // * Offsets are calculated from the beginning of the current area: Header, Params, Data:
        //     An offset stored in the Params area is calculated from the beginning of the Params section.
        //     An offset stored in the Data area is calculated from the beginning of the Data section.

        // ** The length of dynamic array contents are stored in the field immediately preceeding the contents.

        // [1]: https://solidity.readthedocs.io/en/develop/abi-spec.html

        assembly {

            // Areas below may use the following variables:
            //   1. <area>Start   -- Start of this area in memory
            //   2. <area>End     -- End of this area in memory. This value may
            //                       be precomputed (before writing contents),
            //                       or it may be computed as contents are written.
            //   3. <area>Offset  -- Current offset into area. If an area's End
            //                       is precomputed, this variable tracks the
            //                       offsets of contents as they are written.

            /////// Setup Header Area ///////
            // Load free memory pointer
            fillOrderCalldata := mload(0x40)
            // bytes4(keccak256("fillOrder((address,address,address,address,uint256,uint256,uint256,uint256,uint256,uint256,bytes,bytes),uint256,bytes)"))
            // = 0xb4be83d5
            // Leave 0x20 bytes to store the length
            mstore(add(fillOrderCalldata, 0x20), 0xb4be83d500000000000000000000000000000000000000000000000000000000)
            let headerAreaEnd := add(fillOrderCalldata, 0x24)

            /////// Setup Params Area ///////
            // This area is preallocated and written to later.
            // This is because we need to fill in offsets that have not yet been calculated.
            let paramsAreaStart := headerAreaEnd
            let paramsAreaEnd := add(paramsAreaStart, 0x60)
            let paramsAreaOffset := paramsAreaStart

            /////// Setup Data Area ///////
            let dataAreaStart := paramsAreaEnd
            let dataAreaEnd := dataAreaStart

            // Offset from the source data we're reading from
            let sourceOffset := order
            // arrayLenBytes and arrayLenWords track the length of a dynamically-allocated bytes array.
            let arrayLenBytes := 0
            let arrayLenWords := 0

            /////// Write order Struct ///////
            // Write memory location of Order, relative to the start of the
            // parameter list, then increment the paramsAreaOffset respectively.
            mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))
            paramsAreaOffset := add(paramsAreaOffset, 0x20)

            // Write values for each field in the order
            // It would be nice to use a loop, but we save on gas by writing
            // the stores sequentially.
            mstore(dataAreaEnd, mload(sourceOffset))                            // makerAddress
            mstore(add(dataAreaEnd, 0x20), mload(add(sourceOffset, 0x20)))      // takerAddress
            mstore(add(dataAreaEnd, 0x40), mload(add(sourceOffset, 0x40)))      // feeRecipientAddress
            mstore(add(dataAreaEnd, 0x60), mload(add(sourceOffset, 0x60)))      // senderAddress
            mstore(add(dataAreaEnd, 0x80), mload(add(sourceOffset, 0x80)))      // makerAssetAmount
            mstore(add(dataAreaEnd, 0xA0), mload(add(sourceOffset, 0xA0)))      // takerAssetAmount
            mstore(add(dataAreaEnd, 0xC0), mload(add(sourceOffset, 0xC0)))      // makerFeeAmount
            mstore(add(dataAreaEnd, 0xE0), mload(add(sourceOffset, 0xE0)))      // takerFeeAmount
            mstore(add(dataAreaEnd, 0x100), mload(add(sourceOffset, 0x100)))    // expirationTimeSeconds
            mstore(add(dataAreaEnd, 0x120), mload(add(sourceOffset, 0x120)))    // salt
            mstore(add(dataAreaEnd, 0x140), mload(add(sourceOffset, 0x140)))    // Offset to makerAssetData
            mstore(add(dataAreaEnd, 0x160), mload(add(sourceOffset, 0x160)))    // Offset to takerAssetData
            dataAreaEnd := add(dataAreaEnd, 0x180)
            sourceOffset := add(sourceOffset, 0x180)

            // Write offset to <order.makerAssetData>
            mstore(add(dataAreaStart, mul(10, 0x20)), sub(dataAreaEnd, dataAreaStart))

            // Calculate length of <order.makerAssetData>
            sourceOffset := mload(add(order, 0x140)) // makerAssetData
            arrayLenBytes := mload(sourceOffset)
            sourceOffset := add(sourceOffset, 0x20)
            arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)

            // Write length of <order.makerAssetData>
            mstore(dataAreaEnd, arrayLenBytes)
            dataAreaEnd := add(dataAreaEnd, 0x20)

            // Write contents of <order.makerAssetData>
            for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
                mstore(dataAreaEnd, mload(sourceOffset))
                dataAreaEnd := add(dataAreaEnd, 0x20)
                sourceOffset := add(sourceOffset, 0x20)
            }

            // Write offset to <order.takerAssetData>
            mstore(add(dataAreaStart, mul(11, 0x20)), sub(dataAreaEnd, dataAreaStart))

            // Calculate length of <order.takerAssetData>
            sourceOffset := mload(add(order, 0x160)) // takerAssetData
            arrayLenBytes := mload(sourceOffset)
            sourceOffset := add(sourceOffset, 0x20)
            arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)

            // Write length of <order.takerAssetData>
            mstore(dataAreaEnd, arrayLenBytes)
            dataAreaEnd := add(dataAreaEnd, 0x20)

            // Write contents of  <order.takerAssetData>
            for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
                mstore(dataAreaEnd, mload(sourceOffset))
                dataAreaEnd := add(dataAreaEnd, 0x20)
                sourceOffset := add(sourceOffset, 0x20)
            }

            /////// Write takerAssetFillAmount ///////
            mstore(paramsAreaOffset, takerAssetFillAmount)
            paramsAreaOffset := add(paramsAreaOffset, 0x20)

            /////// Write signature ///////
            // Write offset to paramsArea
            mstore(paramsAreaOffset, sub(dataAreaEnd, paramsAreaStart))

            // Calculate length of signature
            sourceOffset := signature
            arrayLenBytes := mload(sourceOffset)
            sourceOffset := add(sourceOffset, 0x20)
            arrayLenWords := div(add(arrayLenBytes, 0x1F), 0x20)

            // Write length of signature
            mstore(dataAreaEnd, arrayLenBytes)
            dataAreaEnd := add(dataAreaEnd, 0x20)

            // Write contents of signature
            for {let i := 0} lt(i, arrayLenWords) {i := add(i, 1)} {
                mstore(dataAreaEnd, mload(sourceOffset))
                dataAreaEnd := add(dataAreaEnd, 0x20)
                sourceOffset := add(sourceOffset, 0x20)
            }

            // Set length of calldata
            mstore(
                fillOrderCalldata,
                sub(dataAreaEnd, add(fillOrderCalldata, 0x20))
            )
        }

        return fillOrderCalldata;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/MixinExchangeWrapper.sol

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






contract MixinExchangeWrapper is
    LibAbiEncoder,
    LibFillResults,
    LibMath,
    LibConstants,
    MExchangeWrapper
{

    /// @dev Fills the input order.
    ///      Returns false if the transaction would otherwise revert.
    /// @param order Order struct containing order specifications.
    /// @param takerAssetFillAmount Desired amount of takerAsset to sell.
    /// @param signature Proof that order has been created by maker.
    /// @return Amounts filled and fees paid by maker and taker.
    function fillOrderNoThrow(
        LibOrder.Order memory order,
        uint256 takerAssetFillAmount,
        bytes memory signature
    )
        internal
        returns (FillResults memory fillResults)
    {
        // ABI encode calldata for `fillOrder`
        bytes memory fillOrderCalldata = abiEncodeFillOrder(
            order,
            takerAssetFillAmount,
            signature
        );

        address exchange = address(EXCHANGE);

        // Call `fillOrder` and handle any exceptions gracefully
        assembly {
            let success := call(
                gas,                                // forward all gas, TODO: look into gas consumption of assert/throw
                exchange,                           // call address of Exchange contract
                0,                                  // transfer 0 wei
                add(fillOrderCalldata, 32),         // pointer to start of input (skip array length in first 32 bytes)
                mload(fillOrderCalldata),           // length of input
                fillOrderCalldata,                  // write output over input
                128                                 // output size is 128 bytes
            )
            switch success
            case 0 {
                mstore(fillResults, 0)
                mstore(add(fillResults, 32), 0)
                mstore(add(fillResults, 64), 0)
                mstore(add(fillResults, 96), 0)
            }
            case 1 {
                mstore(fillResults, mload(fillOrderCalldata))
                mstore(add(fillResults, 32), mload(add(fillOrderCalldata, 32)))
                mstore(add(fillResults, 64), mload(add(fillOrderCalldata, 64)))
                mstore(add(fillResults, 96), mload(add(fillOrderCalldata, 96)))
            }
        }
        return fillResults;
    }

    /// @dev Synchronously executes multiple calls of fillOrder until total amount of WETH has been sold by taker.
    ///      Returns false if the transaction would otherwise revert.
    /// @param orders Array of order specifications.
    /// @param wethSellAmount Desired amount of WETH to sell.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketSellWeth(
        LibOrder.Order[] memory orders,
        uint256 wethSellAmount,
        bytes[] memory signatures
    )
        internal
        returns (FillResults memory totalFillResults)
    {
        bytes memory makerAssetData = orders[0].makerAssetData;
        bytes memory wethAssetData = WETH_ASSET_DATA;

        uint256 ordersLength = orders.length;
        for (uint256 i = 0; i != ordersLength; i++) {

            // We assume that asset being bought by taker is the same for each order.
            // We assume that asset being sold by taker is WETH for each order.
            orders[i].makerAssetData = makerAssetData;
            orders[i].takerAssetData = wethAssetData;

            // Calculate the remaining amount of WETH to sell
            uint256 remainingTakerAssetFillAmount = safeSub(wethSellAmount, totalFillResults.takerAssetFilledAmount);

            // Attempt to sell the remaining amount of WETH
            FillResults memory singleFillResults = fillOrderNoThrow(
                orders[i],
                remainingTakerAssetFillAmount,
                signatures[i]
            );

            // Update amounts filled and fees paid by maker and taker
            addFillResults(totalFillResults, singleFillResults);

            // Stop execution if the entire amount of takerAsset has been sold
            if (totalFillResults.takerAssetFilledAmount >= wethSellAmount) {
                break;
            }
        }
        return totalFillResults;
    }

    /// @dev Synchronously executes multiple fill orders in a single transaction until total amount is bought by taker.
    ///      Returns false if the transaction would otherwise revert.
    ///      The asset being sold by taker must always be WETH.
    /// @param orders Array of order specifications.
    /// @param makerAssetFillAmount Desired amount of makerAsset to buy.
    /// @param signatures Proofs that orders have been signed by makers.
    /// @return Amounts filled and fees paid by makers and taker.
    function marketBuyWithWeth(
        LibOrder.Order[] memory orders,
        uint256 makerAssetFillAmount,
        bytes[] memory signatures
    )
        internal
        returns (FillResults memory totalFillResults)
    {
        bytes memory makerAssetData = orders[0].makerAssetData;
        bytes memory wethAssetData = WETH_ASSET_DATA;

        uint256 ordersLength = orders.length;
        for (uint256 i = 0; i != ordersLength; i++) {

            // We assume that asset being bought by taker is the same for each order.
            // We assume that asset being sold by taker is WETH for each order.
            orders[i].makerAssetData = makerAssetData;
            orders[i].takerAssetData = wethAssetData;

            // Calculate the remaining amount of makerAsset to buy
            uint256 remainingMakerAssetFillAmount = safeSub(makerAssetFillAmount, totalFillResults.makerAssetFilledAmount);

            // Convert the remaining amount of makerAsset to buy into remaining amount
            // of takerAsset to sell, assuming entire amount can be sold in the current order
            uint256 remainingTakerAssetFillAmount = getPartialAmount(
                orders[i].takerAssetAmount,
                orders[i].makerAssetAmount,
                remainingMakerAssetFillAmount
            );

            // Attempt to sell the remaining amount of takerAsset
            FillResults memory singleFillResults = fillOrderNoThrow(
                orders[i],
                remainingTakerAssetFillAmount,
                signatures[i]
            );

            // Update amounts filled and fees paid by maker and taker
            addFillResults(totalFillResults, singleFillResults);

            // Stop execution if the entire amount of makerAsset has been bought
            if (totalFillResults.makerAssetFilledAmount >= makerAssetFillAmount) {
                break;
            }
        }
        return totalFillResults;
    }

    /// @dev Buys zrxBuyAmount of ZRX fee tokens, taking into account ZRX fees for each order. This will guarantee
    ///      that at least zrxBuyAmount of ZRX is purchased (sometimes slightly over due to rounding issues).
    ///      It is possible that a request to buy 200 ZRX will require purchasing 202 ZRX
    ///      as 2 ZRX is required to purchase the 200 ZRX fee tokens. This guarantees at least 200 ZRX for future purchases.
    ///      The asset being sold by taker must always be WETH. 
    /// @param orders Array of order specifications containing ZRX as makerAsset and WETH as takerAsset.
    /// @param zrxBuyAmount Desired amount of ZRX to buy.
    /// @param signatures Proofs that orders have been created by makers.
    /// @return totalFillResults Amounts filled and fees paid by maker and taker.
    function marketBuyZrxWithWeth(
        LibOrder.Order[] memory orders,
        uint256 zrxBuyAmount,
        bytes[] memory signatures
    )
        internal
        returns (FillResults memory totalFillResults)
    {
        // Do nothing if zrxBuyAmount == 0
        if (zrxBuyAmount == 0) {
            return totalFillResults;
        }

        bytes memory zrxAssetData = ZRX_ASSET_DATA;
        bytes memory wethAssetData = WETH_ASSET_DATA;
        uint256 zrxPurchased = 0;

        uint256 ordersLength = orders.length;
        for (uint256 i = 0; i != ordersLength; i++) {

            // All of these are ZRX/WETH, so we can drop the respective assetData from calldata.
            orders[i].makerAssetData = zrxAssetData;
            orders[i].takerAssetData = wethAssetData;

            // Calculate the remaining amount of ZRX to buy.
            uint256 remainingZrxBuyAmount = safeSub(zrxBuyAmount, zrxPurchased);

            // Convert the remaining amount of ZRX to buy into remaining amount
            // of WETH to sell, assuming entire amount can be sold in the current order.
            uint256 remainingWethSellAmount = getPartialAmount(
                orders[i].takerAssetAmount,
                safeSub(orders[i].makerAssetAmount, orders[i].takerFee),  // our exchange rate after fees 
                remainingZrxBuyAmount
            );

            // Attempt to sell the remaining amount of WETH.
            FillResults memory singleFillResult = fillOrderNoThrow(
                orders[i],
                safeAdd(remainingWethSellAmount, 1),  // we add 1 wei to the fill amount to make up for rounding errors
                signatures[i]
            );

            // Update amounts filled and fees paid by maker and taker.
            addFillResults(totalFillResults, singleFillResult);
            zrxPurchased = safeSub(totalFillResults.makerAssetFilledAmount, totalFillResults.takerFeePaid);

            // Stop execution if the entire amount of ZRX has been bought.
            if (zrxPurchased >= zrxBuyAmount) {
                break;
            }
        }

        return totalFillResults;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Protocol_v2/0x-monorepo-a05b14e4d9659be1cc495ee33fd8962ce773f87f/packages/contracts/src/2.0.0/forwarder/Forwarder.sol

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





// solhint-disable no-empty-blocks
contract Forwarder is
    LibConstants,
    MixinWeth,
    MixinAssets,
    MixinExchangeWrapper,
    MixinForwarderCore
{

    constructor (
        address _exchange,
        address _etherToken,
        address _zrxToken,
        bytes memory _zrxAssetData,
        bytes memory _wethAssetData
    )
        public
        LibConstants(
            _exchange,
            _etherToken,
            _zrxToken,
            _zrxAssetData,
            _wethAssetData
        )
        MixinForwarderCore()
    {}
}
