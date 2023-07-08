// File: @0x/contracts-utils/contracts/src/v06/errors/LibRichErrorsV06.sol

// SPDX-License-Identifier: Apache-2.0
/*

  Copyright 2020 ZeroEx Intl.

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

pragma solidity ^0.6.5;

library LibRichErrorsV06 {
    // bytes4(keccak256("Error(string)"))
    bytes4 internal constant STANDARD_ERROR_SELECTOR = 0x08c379a0;

    /// @dev ABI encode a standard, string revert error payload.
    ///      This is the same payload that would be included by a `revert(string)`
    ///      solidity statement. It has the function signature `Error(string)`.
    /// @param message The error string.
    /// @return The ABI encoded error.
    function StandardError(string memory message) internal pure returns (bytes memory) {
        return abi.encodeWithSelector(STANDARD_ERROR_SELECTOR, bytes(message));
    }

    /// @dev Reverts an encoded rich revert reason `errorData`.
    /// @param errorData ABI encoded error data.
    function rrevert(bytes memory errorData) internal pure {
        assembly {
            revert(add(errorData, 0x20), mload(errorData))
        }
    }
}

// File: @0x/contracts-utils/contracts/src/v06/errors/LibOwnableRichErrorsV06.sol

// SPDX-License-Identifier: Apache-2.0
/*

  Copyright 2020 ZeroEx Intl.

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
pragma solidity ^0.6.5;

library LibOwnableRichErrorsV06 {
    // bytes4(keccak256("OnlyOwnerError(address,address)"))
    bytes4 internal constant ONLY_OWNER_ERROR_SELECTOR = 0x1de45ad1;

    // bytes4(keccak256("TransferOwnerToZeroError()"))
    bytes internal constant TRANSFER_OWNER_TO_ZERO_ERROR_BYTES = hex"e69edc3e";

    function OnlyOwnerError(address sender, address owner) internal pure returns (bytes memory) {
        return abi.encodeWithSelector(ONLY_OWNER_ERROR_SELECTOR, sender, owner);
    }

    function TransferOwnerToZeroError() internal pure returns (bytes memory) {
        return TRANSFER_OWNER_TO_ZERO_ERROR_BYTES;
    }
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/zero-ex/contracts/src/vendor/ILiquidityProvider.sol

/*

  Copyright 2020 ZeroEx Intl.

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

pragma solidity ^0.6.5;

interface ILiquidityProvider {

    /// @dev Trades `inputToken` for `outputToken`. The amount of `inputToken`
    ///      to sell must be transferred to the contract prior to calling this
    ///      function to trigger the trade.
    /// @param inputToken The token being sold.
    /// @param outputToken The token being bought.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of `outputToken` to buy.
    /// @param auxiliaryData Arbitrary auxiliary data supplied to the contract.
    /// @return boughtAmount The amount of `outputToken` bought.
    function sellTokenForToken(
        address inputToken,
        address outputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external
        returns (uint256 boughtAmount);

    /// @dev Trades ETH for token. ETH must either be attached to this function
    ///      call or sent to the contract prior to calling this function to
    ///      trigger the trade.
    /// @param outputToken The token being bought.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of `outputToken` to buy.
    /// @param auxiliaryData Arbitrary auxiliary data supplied to the contract.
    /// @return boughtAmount The amount of `outputToken` bought.
    function sellEthForToken(
        address outputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external
        payable
        returns (uint256 boughtAmount);

    /// @dev Trades token for ETH. The token must be sent to the contract prior
    ///      to calling this function to trigger the trade.
    /// @param inputToken The token being sold.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of ETH to buy.
    /// @param auxiliaryData Arbitrary auxiliary data supplied to the contract.
    /// @return boughtAmount The amount of ETH bought.
    function sellTokenForEth(
        address inputToken,
        address payable recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external
        returns (uint256 boughtAmount);

    /// @dev Quotes the amount of `outputToken` that would be obtained by
    ///      selling `sellAmount` of `inputToken`.
    /// @param inputToken Address of the taker token (what to sell). Use
    ///        the wETH address if selling ETH.
    /// @param outputToken Address of the maker token (what to buy). Use
    ///        the wETH address if buying ETH.
    /// @param sellAmount Amount of `inputToken` to sell.
    /// @return outputTokenAmount Amount of `outputToken` that would be obtained.
    function getSellQuote(
        address inputToken,
        address outputToken,
        uint256 sellAmount
    )
        external
        view
        returns (uint256 outputTokenAmount);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/zero-ex/contracts/src/vendor/v3/IERC20Bridge.sol

/*

  Copyright 2020 ZeroEx Intl.

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

pragma solidity ^0.6.5;

interface IERC20Bridge {

    /// @dev Emitted when a trade occurs.
    /// @param inputToken The token the bridge is converting from.
    /// @param outputToken The token the bridge is converting to.
    /// @param inputTokenAmount Amount of input token.
    /// @param outputTokenAmount Amount of output token.
    /// @param from The `from` address in `bridgeTransferFrom()`
    /// @param to The `to` address in `bridgeTransferFrom()`
    event ERC20BridgeTransfer(
        address inputToken,
        address outputToken,
        uint256 inputTokenAmount,
        uint256 outputTokenAmount,
        address from,
        address to
    );

    /// @dev Transfers `amount` of the ERC20 `tokenAddress` from `from` to `to`.
    /// @param tokenAddress The address of the ERC20 token to transfer.
    /// @param from Address to transfer asset from.
    /// @param to Address to transfer asset to.
    /// @param amount Amount of asset to transfer.
    /// @param bridgeData Arbitrary asset data needed by the bridge contract.
    /// @return success The magic bytes `0xdc1600f3` if successful.
    function bridgeTransferFrom(
        address tokenAddress,
        address from,
        address to,
        uint256 amount,
        bytes calldata bridgeData
    )
        external
        returns (bytes4 success);
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/zero-ex/contracts/src/external/ILiquidityProviderSandbox.sol

/*

  Copyright 2020 ZeroEx Intl.

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

pragma solidity ^0.6.5;
pragma experimental ABIEncoderV2;


interface ILiquidityProviderSandbox {

    /// @dev Calls `sellTokenForToken` on the given `provider` contract to
    ///      trigger a trade.
    /// @param provider The address of the on-chain liquidity provider.
    /// @param inputToken The token being sold.
    /// @param outputToken The token being bought.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of `outputToken` to buy.
    /// @param auxiliaryData Auxiliary data supplied to the `provider` contract.
    function executeSellTokenForToken(
        address provider,
        address inputToken,
        address outputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external;

    /// @dev Calls `sellEthForToken` on the given `provider` contract to
    ///      trigger a trade.
    /// @param provider The address of the on-chain liquidity provider.
    /// @param outputToken The token being bought.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of `outputToken` to buy.
    /// @param auxiliaryData Auxiliary data supplied to the `provider` contract.
    function executeSellEthForToken(
        address provider,
        address outputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external;

    /// @dev Calls `sellTokenForEth` on the given `provider` contract to
    ///      trigger a trade.
    /// @param provider The address of the on-chain liquidity provider.
    /// @param inputToken The token being sold.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of ETH to buy.
    /// @param auxiliaryData Auxiliary data supplied to the `provider` contract.
    function executeSellTokenForEth(
        address provider,
        address inputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/consensys-0x_Exchange_v4/protocol-475b608338561a1dce3199bfb9fb59ee9372149b/contracts/zero-ex/contracts/src/external/LiquidityProviderSandbox.sol

/*
  Copyright 2020 ZeroEx Intl.
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

pragma solidity ^0.6.5;
pragma experimental ABIEncoderV2;





/// @dev A permissionless contract through which the ZeroEx contract can
///      safely trigger a trade on an external `ILiquidityProvider` contract.
contract LiquidityProviderSandbox is
    ILiquidityProviderSandbox
{
    using LibRichErrorsV06 for bytes;

    /// @dev Store the owner as an immutable.
    address public immutable owner;

    constructor(address owner_)
        public
    {
        owner = owner_;
    }

    /// @dev Allows only the (immutable) owner to call a function.
    modifier onlyOwner() virtual {
        if (msg.sender != owner) {
            LibOwnableRichErrorsV06.OnlyOwnerError(
                msg.sender,
                owner
            ).rrevert();
        }
        _;
    }

    /// @dev Calls `sellTokenForToken` on the given `provider` contract to
    ///      trigger a trade.
    /// @param provider The address of the on-chain liquidity provider.
    /// @param inputToken The token being sold.
    /// @param outputToken The token being bought.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of `outputToken` to buy.
    /// @param auxiliaryData Auxiliary data supplied to the `provider` contract.
    function executeSellTokenForToken(
        address provider,
        address inputToken,
        address outputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external
        onlyOwner
        override
    {
        try ILiquidityProvider(provider).sellTokenForToken(
            inputToken,
            outputToken,
            recipient,
            minBuyAmount,
            auxiliaryData
        ) {} catch {
            IERC20Bridge(provider).bridgeTransferFrom(
                outputToken,
                provider,
                recipient,
                minBuyAmount,
                auxiliaryData
            );
        }
    }

    /// @dev Calls `sellEthForToken` on the given `provider` contract to
    ///      trigger a trade.
    /// @param provider The address of the on-chain liquidity provider.
    /// @param outputToken The token being bought.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of `outputToken` to buy.
    /// @param auxiliaryData Auxiliary data supplied to the `provider` contract.
    function executeSellEthForToken(
        address provider,
        address outputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external
        onlyOwner
        override
    {
        ILiquidityProvider(provider).sellEthForToken(
            outputToken,
            recipient,
            minBuyAmount,
            auxiliaryData
        );
    }

    /// @dev Calls `sellTokenForEth` on the given `provider` contract to
    ///      trigger a trade.
    /// @param provider The address of the on-chain liquidity provider.
    /// @param inputToken The token being sold.
    /// @param recipient The recipient of the bought tokens.
    /// @param minBuyAmount The minimum acceptable amount of ETH to buy.
    /// @param auxiliaryData Auxiliary data supplied to the `provider` contract.
    function executeSellTokenForEth(
        address provider,
        address inputToken,
        address recipient,
        uint256 minBuyAmount,
        bytes calldata auxiliaryData
    )
        external
        onlyOwner
        override
    {
        ILiquidityProvider(provider).sellTokenForEth(
            inputToken,
            payable(recipient),
            minBuyAmount,
            auxiliaryData
        );
    }
}
