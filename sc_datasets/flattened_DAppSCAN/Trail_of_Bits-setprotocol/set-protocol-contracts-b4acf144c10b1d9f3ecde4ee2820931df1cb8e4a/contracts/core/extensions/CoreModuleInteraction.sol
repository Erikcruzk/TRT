// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

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
abstract contract ReentrancyGuard {
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

    constructor () internal {
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

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-b4acf144c10b1d9f3ecde4ee2820931df1cb8e4a/contracts/core/interfaces/ITransferProxy.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.4;

/**
 * @title ITransferProxy
 * @author Set Protocol
 *
 * The ITransferProxy interface provides a light-weight, structured way to interact with the
 * TransferProxy contract from another contract.
 */
interface ITransferProxy {

    /* ============ External Functions ============ */

    /**
     * Transfers tokens from an address (that has set allowance on the proxy).
     * Can only be called by authorized core contracts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _quantity       The number of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function transfer(
        address _token,
        uint256 _quantity,
        address _from,
        address _to
    )
        external;

    /**
     * Transfers tokens from an address (that has set allowance on the proxy).
     * Can only be called by authorized core contracts.
     *
     * @param  _tokens         The addresses of the ERC20 token
     * @param  _quantities     The numbers of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function batchTransfer(
        address[] calldata _tokens,
        uint256[] calldata _quantities,
        address _from,
        address _to
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-b4acf144c10b1d9f3ecde4ee2820931df1cb8e4a/contracts/core/interfaces/IVault.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.4;

/**
 * @title IVault
 * @author Set Protocol
 *
 * The IVault interface provides a light-weight, structured way to interact with the Vault
 * contract from another contract.
 */
interface IVault {

    /*
     * Withdraws user's unassociated tokens to user account. Can only be
     * called by authorized core contracts.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _to             The address to transfer token to
     * @param  _quantity       The number of tokens to transfer
     */
    function withdrawTo(
        address _token,
        address _to,
        uint256 _quantity
    )
        external;

    /*
     * Increment quantity owned of a token for a given address. Can
     * only be called by authorized core contracts.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _owner           The address of the token owner
     * @param  _quantity        The number of tokens to attribute to owner
     */
    function incrementTokenOwner(
        address _token,
        address _owner,
        uint256 _quantity
    )
        external;

    /*
     * Decrement quantity owned of a token for a given address. Can only
     * be called by authorized core contracts.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _owner           The address of the token owner
     * @param  _quantity        The number of tokens to deattribute to owner
     */
    function decrementTokenOwner(
        address _token,
        address _owner,
        uint256 _quantity
    )
        external;

    /**
     * Transfers tokens associated with one account to another account in the vault
     *
     * @param  _token          Address of token being transferred
     * @param  _from           Address token being transferred from
     * @param  _to             Address token being transferred to
     * @param  _quantity       Amount of tokens being transferred
     */

    function transferBalance(
        address _token,
        address _from,
        address _to,
        uint256 _quantity
    )
        external;


    /*
     * Withdraws user's unassociated tokens to user account. Can only be
     * called by authorized core contracts.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchWithdrawTo(
        address[] calldata _tokens,
        address _to,
        uint256[] calldata _quantities
    )
        external;

    /*
     * Increment quantites owned of a collection of tokens for a given address. Can
     * only be called by authorized core contracts.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchIncrementTokenOwner(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

    /*
     * Decrements quantites owned of a collection of tokens for a given address. Can
     * only be called by authorized core contracts.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchDecrementTokenOwner(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external;

   /**
     * Transfers tokens associated with one account to another account in the vault
     *
     * @param  _tokens           Addresses of tokens being transferred
     * @param  _from             Address tokens being transferred from
     * @param  _to               Address tokens being transferred to
     * @param  _quantities       Amounts of tokens being transferred
     */
    function batchTransferBalance(
        address[] calldata _tokens,
        address _from,
        address _to,
        uint256[] calldata _quantities
    )
        external;

    /*
     * Get balance of particular contract for owner.
     *
     * @param  _token    The address of the ERC20 token
     * @param  _owner    The address of the token owner
     */
    function getOwnerBalance(
        address _token,
        address _owner
    )
        external
        view
        returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-b4acf144c10b1d9f3ecde4ee2820931df1cb8e4a/contracts/core/lib/CoreState.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.4;


/**
 * @title CoreState
 * @author Set Protocol
 *
 * The CoreState library maintains all state for the Core contract thus
 * allowing it to operate across multiple mixins.
 */
contract CoreState {

    /* ============ Structs ============ */

    struct State {
        // Protocol state of operation
        uint8 operationState;

        // Address of the TransferProxy contract
        address transferProxy;

        // Address of the Vault contract
        address vault;

        // Instance of transferProxy contract
        ITransferProxy transferProxyInstance;

        // Instance of Vault Contract
        IVault vaultInstance;

        // Mapping of exchange enumeration to address
        mapping(uint8 => address) exchangeIds;

        // Mapping of approved modules
        mapping(address => bool) validModules;

        // Mapping of tracked SetToken factories
        mapping(address => bool) validFactories;

        // Mapping of tracked rebalancing price libraries
        mapping(address => bool) validPriceLibraries;

        // Mapping of tracked SetTokens
        mapping(address => bool) validSets;

        // Mapping of tracked disabled SetTokens
        mapping(address => bool) disabledSets;

        // Array of tracked SetTokens
        address[] setTokens;

        // Array of tracked modules
        address[] modules;

        // Array of tracked factories
        address[] factories;

        // Array of tracked exchange wrappers
        address[] exchanges;

        // Array of tracked auction price libraries
        address[] priceLibraries;
    }

    /* ============ State Variables ============ */

    State public state;

    /* ============ Public Getters ============ */

    /**
     * Return uint8 representing the operational state of the protocol
     *
     * @return uint8           Uint8 representing the operational state of the protocol
     */
    function operationState()
        external
        view
        returns (uint8)
    {
        return state.operationState;
    }

    /**
     * Return address belonging to given exchangeId.
     *
     * @param  _exchangeId       ExchangeId number
     * @return address           Address belonging to given exchangeId
     */
    function exchangeIds(
        uint8 _exchangeId
    )
        external
        view
        returns (address)
    {
        return state.exchangeIds[_exchangeId];
    }

    /**
     * Return transferProxy address.
     *
     * @return address       transferProxy address
     */
    function transferProxy()
        external
        view
        returns (address)
    {
        return state.transferProxy;
    }

    /**
     * Return vault address
     *
     * @return address        vault address
     */
    function vault()
        external
        view
        returns (address)
    {
        return state.vault;
    }

    /**
     * Return boolean indicating if address is valid factory.
     *
     * @param  _factory       Factory address
     * @return bool           Boolean indicating if enabled factory
     */
    function validFactories(
        address _factory
    )
        external
        view
        returns (bool)
    {
        return state.validFactories[_factory];
    }

    /**
     * Return boolean indicating if address is valid module.
     *
     * @param  _module        Factory address
     * @return bool           Boolean indicating if enabled factory
     */
    function validModules(
        address _module
    )
        external
        view
        returns (bool)
    {
        return state.validModules[_module];
    }

    /**
     * Return boolean indicating if address is valid Set.
     *
     * @param  _set           Set address
     * @return bool           Boolean indicating if valid Set
     */
    function validSets(
        address _set
    )
        external
        view
        returns (bool)
    {
        return state.validSets[_set];
    }

    /**
     * Return boolean indicating if address is a disabled Set.
     *
     * @param  _set           Set address
     * @return bool           Boolean indicating if is a disabled Set
     */
    function disabledSets(
        address _set
    )
        external
        view
        returns (bool)
    {
        return state.disabledSets[_set];
    }

    /**
     * Return boolean indicating if address is a valid Rebalancing Price Library.
     *
     * @param  _priceLibrary    Price library address
     * @return bool             Boolean indicating if valid Price Library
     */
    function validPriceLibraries(
        address _priceLibrary
    )
        external
        view
        returns (bool)
    {
        return state.validPriceLibraries[_priceLibrary];
    }

    /**
     * Return array of all valid Set Tokens.
     *
     * @return address[]      Array of valid Set Tokens
     */
    function setTokens()
        external
        view
        returns (address[] memory)
    {
        return state.setTokens;
    }

    /**
     * Return array of all valid Modules.
     *
     * @return address[]      Array of valid modules
     */
    function modules()
        external
        view
        returns (address[] memory)
    {
        return state.modules;
    }

    /**
     * Return array of all valid factories.
     *
     * @return address[]      Array of valid factories
     */
    function factories()
        external
        view
        returns (address[] memory)
    {
        return state.factories;
    }

    /**
     * Return array of all valid exchange wrappers.
     *
     * @return address[]      Array of valid exchange wrappers
     */
    function exchanges()
        external
        view
        returns (address[] memory)
    {
        return state.exchanges;
    }

    /**
     * Return array of all valid price libraries.
     *
     * @return address[]      Array of valid price libraries
     */
    function priceLibraries()
        external
        view
        returns (address[] memory)
    {
        return state.priceLibraries;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-b4acf144c10b1d9f3ecde4ee2820931df1cb8e4a/contracts/core/interfaces/ICoreAccounting.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.4;


/**
 * @title ICoreAccounting
 * @author Set Protocol
 *
 * The ICoreAccounting Contract defines all the functions exposed in the CoreIssuance
 * extension.
 */
contract ICoreAccounting {

    /* ============ Internal Functions ============ */

    /**
     * Internal function that deposits multiple tokens to the vault.
     * Quantities should be in the order of the addresses of the tokens being deposited.
     *
     * @param  _from              Address to transfer tokens from
     * @param  _to                Address to credit for deposits
     * @param  _tokens            Array of the addresses of the tokens being deposited
     * @param  _quantities        Array of the amounts of tokens to deposit
     */
    function batchDepositInternal(
        address _from,
        address _to,
        address[] memory _tokens,
        uint[] memory _quantities
    )
        internal;

    /**
     * Internal function that withdraws multiple tokens from the vault.
     * Quantities should be in the order of the addresses of the tokens being withdrawn.
     *
     * @param  _from              Address to decredit for withdrawals
     * @param  _to                Address to transfer tokens to
     * @param  _tokens            Array of the addresses of the tokens being withdrawn
     * @param  _quantities        Array of the amounts of tokens to withdraw
     */
    function batchWithdrawInternal(
        address _from,
        address _to,
        address[] memory _tokens,
        uint256[] memory _quantities
    )
        internal;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-b4acf144c10b1d9f3ecde4ee2820931df1cb8e4a/contracts/core/interfaces/ICoreIssuance.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.4;


/**
 * @title ICoreIssuance
 * @author Set Protocol
 *
 * The ICoreIssuance Contract defines all the functions exposed in the CoreIssuance
 * extension.
 */
contract ICoreIssuance {

    /* ============ Internal Functions ============ */

    /**
     * Exchange components for Set tokens, accepting any owner
     *
     * @param  _owner        Address to use tokens from
     * @param  _recipient    Address to issue Set to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueInternal(
        address _owner,
        address _recipient,
        address _set,
        uint256 _quantity
    )
        internal;

    /**
     * Converts recipient's components into Set Tokens held directly in Vault
     *
     * @param _recipient    Address to issue to
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to issue
     */
    function issueInVaultInternal(
        address _recipient,
        address _set,
        uint256 _quantity
    )
        internal;

    /**
     * Exchange Set tokens for underlying components
     *
     * @param _burnAddress       Address to burn tokens from
     * @param _incrementAddress  Address to increment component tokens to
     * @param _set               Address of the Set to redeem
     * @param _quantity          Number of tokens to redeem
     */
    function redeemInternal(
        address _burnAddress,
        address _incrementAddress,
        address _set,
        uint256 _quantity
    )
        internal;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-b4acf144c10b1d9f3ecde4ee2820931df1cb8e4a/contracts/core/extensions/CoreModuleInteraction.sol

/*
    Copyright 2018 Set Labs Inc.

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

pragma solidity 0.5.4;



/**
 * @title CoreModularInteraction
 * @author Set Protocol
 *
 * Extension used to expose internal accounting and issuance functions, vault, and proxy functions
 * to modules.
 */
contract CoreModuleInteraction is
    ICoreAccounting,
    ICoreIssuance,
    CoreState,
    ReentrancyGuard
{
    modifier onlyModule() {
        onlyModuleCallable();
        _;
    }

    function onlyModuleCallable() internal view {
        require(
            state.validModules[msg.sender],
            "Not module"
        );
    }

    /**
     * Exposes internal function that deposits tokens to the vault, exposed to system
     * modules. Quantities should be in the order of the addresses of the tokens being
     * deposited.
     *
     * @param  _from              Address to transfer tokens from
     * @param  _to                Address to credit for deposits
     * @param  _token             Address of the token being deposited
     * @param  _quantity          Amount of tokens to deposit
     */
    function depositModule(
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external
        onlyModule
    {
        address[] memory tokenArray = new address[](1);
        tokenArray[0] = _token;

        uint256[] memory quantityArray = new uint256[](1);
        quantityArray[0] = _quantity;

        batchDepositInternal(
            _from,
            _to,
            tokenArray,
            quantityArray
        );
    }

    /**
     * Exposes internal function that deposits multiple tokens to the vault, exposed to system
     * modules. Quantities should be in the order of the addresses of the tokens being
     * deposited.
     *
     * @param  _from              Address to transfer tokens from
     * @param  _to                Address to credit for deposits
     * @param  _tokens            Array of the addresses of the tokens being deposited
     * @param  _quantities        Array of the amounts of tokens to deposit
     */
    function batchDepositModule(
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external
        onlyModule
    {
        batchDepositInternal(
            _from,
            _to,
            _tokens,
            _quantities
        );
    }

    /**
     * Exposes internal function that withdraws multiple tokens to the vault, exposed to system
     * modules. Quantities should be in the order of the addresses of the tokens being
     * withdrawn.
     *
     * @param  _from              Address to decredit for withdrawals
     * @param  _to                Address to transfer tokens to
     * @param  _token             Address of the token being withdrawn
     * @param  _quantity          Amount of tokens to withdraw
     */
    function withdrawModule(
        address _from,
        address _to,
        address _token,
        uint256 _quantity
    )
        external
        onlyModule
    {        
        address[] memory tokenArray = new address[](1);
        tokenArray[0] = _token;

        uint256[] memory quantityArray = new uint256[](1);
        quantityArray[0] = _quantity;        

        batchWithdrawInternal(
            _from,
            _to,
            tokenArray,
            quantityArray
        );
    }

    /**
     * Exposes internal function that withdraws multiple tokens from the vault, to system
     * modules. Quantities should be in the order of the addresses of the tokens being withdrawn.
     *
     * @param  _from              Address to decredit for withdrawals
     * @param  _to                Address to transfer tokens to
     * @param  _tokens            Array of the addresses of the tokens being withdrawn
     * @param  _quantities        Array of the amounts of tokens to withdraw
     */
    function batchWithdrawModule(
        address _from,
        address _to,
        address[] calldata _tokens,
        uint256[] calldata _quantities
    )
        external
        onlyModule
    {
        batchWithdrawInternal(
            _from,
            _to,
            _tokens,
            _quantities
        );
    }

    /**
     * Expose internal function that exchanges components for Set tokens,
     * accepting any owner, to system modules
     *
     * @param  _componentOwner  Address to use tokens from
     * @param  _setRecipient    Address to issue Set to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueModule(
        address _componentOwner,
        address _setRecipient,
        address _set,
        uint256 _quantity
    )
        external
        onlyModule
    {
        issueInternal(
            _componentOwner,
            _setRecipient,
            _set,
            _quantity
        );
    }

    /**
     * Converts recipient's components into Set Token's held directly in Vault
     *
     * @param _recipient    Address to issue to
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to redeem
     */
    function issueInVaultModule(
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external
        onlyModule
    {
        issueInVaultInternal(
            _recipient,
            _set,
            _quantity
        );
    }

    /**
     * Expose internal function that exchanges Set tokens for components,
     * accepting any owner, to system modules
     *
     * @param  _burnAddress         Address to burn token from
     * @param  _incrementAddress    Address to increment component tokens to
     * @param  _set                 Address of the Set to redeem
     * @param  _quantity            Number of tokens to redeem
     */
    function redeemModule(
        address _burnAddress,
        address _incrementAddress,
        address _set,
        uint256 _quantity
    )
        external
        onlyModule
    {
        redeemInternal(
            _burnAddress,
            _incrementAddress,
            _set,
            _quantity
        );
    }

    /**
     * Expose vault function that increments user's balance in the vault.
     * Available to system modules
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchIncrementTokenOwnerModule(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external
        onlyModule
    {
        state.vaultInstance.batchIncrementTokenOwner(
            _tokens,
            _owner,
            _quantities
        );
    }

    /**
     * Expose vault function that decrement user's balance in the vault
     * Only available to system modules.
     *
     * @param  _tokens          The addresses of the ERC20 tokens
     * @param  _owner           The address of the token owner
     * @param  _quantities      The numbers of tokens to attribute to owner
     */
    function batchDecrementTokenOwnerModule(
        address[] calldata _tokens,
        address _owner,
        uint256[] calldata _quantities
    )
        external
        onlyModule
    {
        state.vaultInstance.batchDecrementTokenOwner(
            _tokens,
            _owner,
            _quantities
        );
    }

    /**
     * Expose vault function that transfer vault balances between users
     * Only available to system modules.
     *
     * @param  _tokens           Addresses of tokens being transferred
     * @param  _from             Address tokens being transferred from
     * @param  _to               Address tokens being transferred to
     * @param  _quantities       Amounts of tokens being transferred
     */
    function batchTransferBalanceModule(
        address[] calldata _tokens,
        address _from,
        address _to,
        uint256[] calldata _quantities
    )
        external
        onlyModule
    {
        state.vaultInstance.batchTransferBalance(
            _tokens,
            _from,
            _to,
            _quantities
        );
    }

    /**
     * Transfers token from one address to another using the transfer proxy.
     * Only available to system modules.
     *
     * @param  _token          The address of the ERC20 token
     * @param  _quantity       The number of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function transferModule(
        address _token,
        uint256 _quantity,
        address _from,
        address _to
    )
        external
        onlyModule
    {
        state.transferProxyInstance.transfer(
            _token,
            _quantity,
            _from,
            _to
        );
    }

    /**
     * Expose transfer proxy function to transfer tokens from one address to another
     * Only available to system modules.
     *
     * @param  _tokens         The addresses of the ERC20 token
     * @param  _quantities     The numbers of tokens to transfer
     * @param  _from           The address to transfer from
     * @param  _to             The address to transfer to
     */
    function batchTransferModule(
        address[] calldata _tokens,
        uint256[] calldata _quantities,
        address _from,
        address _to
    )
        external
        onlyModule
    {
        state.transferProxyInstance.batchTransfer(
            _tokens,
            _quantities,
            _from,
            _to
        );
    }
}
