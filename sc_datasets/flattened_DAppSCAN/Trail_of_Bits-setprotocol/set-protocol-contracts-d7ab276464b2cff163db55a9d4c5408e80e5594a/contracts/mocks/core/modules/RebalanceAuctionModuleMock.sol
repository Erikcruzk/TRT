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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-d7ab276464b2cff163db55a9d4c5408e80e5594a/contracts/core/interfaces/ICore.sol

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

pragma solidity 0.4.25;


/**
 * @title ICore
 * @author Set Protocol
 *
 * The ICore Contract defines all the functions exposed in the Core through its
 * various extensions and is a light weight way to interact with the contract.
 */
interface ICore {
    /**
     * Return transferProxy address.
     *
     * @return address       transferProxy address
     */
    function transferProxy()
        external
        view
        returns(address);

    /**
     * Return vault address.
     *
     * @return address       vault address
     */
    function vault()
        external
        view
        returns(address);

    /**
     * Return address belonging to given exchangeId.
     *
     * @param  _exchangeId       ExchangeId number
     * @return address           Address belonging to given exchangeId
     */
    function exchanges(
        uint8 _exchangeId
    )
        external
        view
        returns(address);

    /*
     * Returns if valid set
     *
     * @return  bool      Returns true if Set created through Core and isn't disabled
     */
    function validSets(address)
        external
        view
        returns (bool);

    /*
     * Returns if valid module
     *
     * @return  bool      Returns true if valid module
     */
    function validModules(address)
        external
        view
        returns (bool);

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
        returns(bool);

    /**
     * Return signatureValidator address
     *
     * @return address        signatureValidator address
     */
    function signatureValidator()
        external
        view
        returns(address);

    /**
     * Exchanges components for Set Tokens
     *
     * @param  _set          Address of set to issue
     * @param  _quantity     Quantity of set to issue
     */
    function issue(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Converts user's components into Set Tokens held directly in Vault instead of user's account
     *
     * @param _set          Address of the Set
     * @param _quantity     Number of tokens to redeem
     */
    function issueInVault(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Function to convert Set Tokens into underlying components
     *
     * @param _set          The address of the Set token
     * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
     */
    function redeem(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Function to convert Set Tokens held in vault into underlying components
     *
     * @param _set          The address of the Set token
     * @param _quantity     The number of tokens to redeem. Should be multiple of natural unit.
     */
    function redeemInVault(
        address _set,
        uint256 _quantity
    )
        external;

    /**
     * Deposit multiple tokens to the vault. Quantities should be in the
     * order of the addresses of the tokens being deposited.
     *
     * @param  _tokens           Array of the addresses of the ERC20 tokens
     * @param  _quantities       Array of the number of tokens to deposit
     */
    function batchDeposit(
        address[] _tokens,
        uint256[] _quantities
    )
        external;

    /**
     * Withdraw multiple tokens from the vault. Quantities should be in the
     * order of the addresses of the tokens being withdrawn.
     *
     * @param  _tokens            Array of the addresses of the ERC20 tokens
     * @param  _quantities        Array of the number of tokens to withdraw
     */
    function batchWithdraw(
        address[] _tokens,
        uint256[] _quantities
    )
        external;

    /**
     * Deposit any quantity of tokens into the vault.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _quantity        The number of tokens to deposit
     */
    function deposit(
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Withdraw a quantity of tokens from the vault.
     *
     * @param  _token           The address of the ERC20 token
     * @param  _quantity        The number of tokens to withdraw
     */
    function withdraw(
        address _token,
        uint256 _quantity
    )
        external;

    /**
     * Transfer tokens associated with the sender's account in vault to another user's
     * account in vault.
     *
     * @param  _token           Address of token being transferred
     * @param  _to              Address of user receiving tokens
     * @param  _quantity        Amount of tokens being transferred
     */
    function internalTransfer(
        address _token,
        address _to,
        uint256 _quantity
    )
        external;

    /**
     * Deploys a new Set Token and adds it to the valid list of SetTokens
     *
     * @param  _factory              The address of the Factory to create from
     * @param  _components           The address of component tokens
     * @param  _units                The units of each component token
     * @param  _naturalUnit          The minimum unit to be issued or redeemed
     * @param  _name                 The bytes32 encoded name of the new Set
     * @param  _symbol               The bytes32 encoded symbol of the new Set
     * @param  _callData             Byte string containing additional call parameters
     * @return setTokenAddress       The address of the new Set
     */
    function create(
        address _factory,
        address[] _components,
        uint256[] _units,
        uint256 _naturalUnit,
        string _name,
        string _symbol,
        bytes _callData
    )
        external
        returns(address);

    /**
     * Exposes internal function that deposits a quantity of tokens to the vault and attributes
     * the tokens respectively, to system modules.
     *
     * @param  _token           Address of token being deposited
     * @param  _from            Address to transfer tokens from
     * @param  _to              Address to credit for deposit
     * @param  _quantity        Amount of tokens to deposit
     */
    function depositModule(
        address _token,
        address _from,
        address _to,
        uint256 _quantity
    )
        external;

    /**
     * Exposes internal function that withdraws a quantity of tokens from the vault and
     * deattributes the tokens respectively, to system modules.
     *
     * @param  _token           Address of token being withdrawn
     * @param  _from            Address to decredit for withdraw
     * @param  _to              Address to transfer tokens to
     * @param  _quantity        Amount of tokens to withdraw
     */
    function withdrawModule(
        address _token,
        address _from,
        address _to,
        uint256 _quantity
    )
        external;

    /**
     * Exposes internal function that deposits multiple tokens to the vault, to system
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
        address[] _tokens,
        uint256[] _quantities
    )
        external;

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
        address[] _tokens,
        uint256[] _quantities
    )
        external;

    /**
     * Expose internal function that exchanges components for Set tokens,
     * accepting any owner, to system modules
     *
     * @param  _owner        Address to use tokens from
     * @param  _recipient    Address to issue Set to
     * @param  _set          Address of the Set to issue
     * @param  _quantity     Number of tokens to issue
     */
    function issueModule(
        address _owner,
        address _recipient,
        address _set,
        uint256 _quantity
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-d7ab276464b2cff163db55a9d4c5408e80e5594a/contracts/core/interfaces/IRebalancingSetToken.sol

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

pragma solidity 0.4.25;

/**
 * @title IRebalancingSetToken
 * @author Set Protocol
 *
 * The IRebalancingSetToken interface provides a light-weight, structured way to interact with the
 * RebalancingSetToken contract from another contract.
 */

interface IRebalancingSetToken {

    /*
     * Get totalSupply of Rebalancing Set
     *
     * @return  totalSupply
     */
    function totalSupply()
        external
        view
        returns (uint256);

    /**
    * Gets the balance of the specified address.
    *
    * @param owner      The address to query the balance of.
    * @return           A uint256 representing the amount owned by the passed address.
    */
    function balanceOf(
        address owner
    ) 
        public
        view
        returns (uint256);

    /*
     * Burn set token for given address.
     * Can only be called by authorized contracts.
     *
     * @param  _from        The address of the redeeming account
     * @param  _quantity    The number of sets to burn from redeemer
     */
    function burn(
        address _from,
        uint256 _quantity
    )
        external;

    /*
     * Place bid during rebalance auction. Can only be called by Core.
     *
     * @param _quantity                 The amount of currentSet to be rebalanced
     * @return combinedTokenArray       Array of token addresses invovled in rebalancing
     * @return inflowUnitArray          Array of amount of tokens inserted into system in bid
     * @return outflowUnitArray         Array of amount of tokens taken out of system in bid
     */
    function placeBid(
        uint256 _quantity
    )
        external
        returns (address[], uint256[], uint256[]);

    /*
     * Get combinedTokenArray of Rebalancing Set
     *
     * @return  combinedTokenArray
     */
    function getCombinedTokenArrayLength()
        external
        view
        returns (uint256);

    /*
     * Get combinedTokenArray of Rebalancing Set
     *
     * @return  combinedTokenArray
     */
    function getCombinedTokenArray()
        external
        view
        returns(address[]);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-d7ab276464b2cff163db55a9d4c5408e80e5594a/contracts/core/interfaces/ISetToken.sol

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

pragma solidity 0.4.25;

/**
 * @title ISetToken
 * @author Set Protocol
 *
 * The ISetToken interface provides a light-weight, structured way to interact with the
 * SetToken contract from another contract.
 */
interface ISetToken {

    /* ============ External Functions ============ */

    /*
     * Get natural unit of Set
     *
     * @return  uint256       Natural unit of Set
     */
    function naturalUnit()
        external
        view
        returns (uint256);

    /*
     * Get addresses of all components in the Set
     *
     * @return  componentAddresses       Array of component tokens
     */
    function getComponents()
        external
        view
        returns(address[]);

    /*
     * Get units of all tokens in Set
     *
     * @return  units       Array of component units
     */
    function getUnits()
        external
        view
        returns(uint256[]);

    /*
     * Checks to make sure token is component of Set
     *
     * @param  _tokenAddress     Address of token being checked
     * @return  bool             True if token is component of Set
     */
    function tokenIsComponent(
        address _tokenAddress
    )
        external
        view
        returns (bool);

    /*
     * Mint set token for given address.
     * Can only be called by authorized contracts.
     *
     * @param  _issuer      The address of the issuing account
     * @param  _quantity    The number of sets to attribute to issuer
     */
    function mint(
        address _issuer,
        uint256 _quantity
    )
        external;

    /*
     * Burn set token for given address
     * Can only be called by authorized contracts
     *
     * @param  _from        The address of the redeeming account
     * @param  _quantity    The number of sets to burn from redeemer
     */
    function burn(
        address _from,
        uint256 _quantity
    )
        external;

    /**
    * Transfer token for a specified address
    *
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(
        address to,
        uint256 value
    )
        external;
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-d7ab276464b2cff163db55a9d4c5408e80e5594a/contracts/core/interfaces/IVault.sol

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

pragma solidity 0.4.25;

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
        address[] _tokens,
        address _to,
        uint256[] _quantities
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
        address[] _tokens,
        address _owner,
        uint256[] _quantities
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
        address[] _tokens,
        address _owner,
        uint256[] _quantities
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
        address[] _tokens,
        address _from,
        address _to,
        uint256[] _quantities
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
        returns (uint256);
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-d7ab276464b2cff163db55a9d4c5408e80e5594a/contracts/core/modules/RebalanceAuctionModule.sol

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

pragma solidity 0.4.25;





/**
 * @title Core Rebalance Auction
 * @author Set Protocol
 *
 * The CoreBidding extension exposes a bid endpoint for use in the RebalancingSetToken
 * auction process.
 */
contract RebalanceAuctionModule is
    ReentrancyGuard
{
    using SafeMath for uint256;

    /* ============ State Variables ============ */

    // Address of Core contract
    address public core;

    ICore public coreInstance;

    // Address of Vault contract
    address public vault;

    IVault public vaultInstance;

    
    /* ============ Events ============ */

    event BidPlaced(
        address bidder,
        uint256 quantity
    );

    /* ============ Constructor ============ */

    /**
     * Constructor function for IssuanceOrderModule
     *
     * @param _core       The address of Core
     * @param _vault       The address of Vault
     */
    constructor(
        address _core,
        address _vault
    )
        public
    {
        // Commit passed address to core state variable
        core = _core;

        coreInstance = ICore(_core);

        // Commit passed address to vault state variable
        vault = _vault;

        vaultInstance = IVault(_vault);
    }

    /* ============ Public Functions ============ */

    /**
     * Bid on rebalancing a given quantity of sets held by a rebalancing token
     *
     * @param  _rebalancingSetToken    Address of the rebalancing token being bid on
     * @param  _quantity               Number of currentSets to rebalance
     */
    function bid(
        address _rebalancingSetToken,
        uint256 _quantity
    )
        external
        nonReentrant
    {
        // Create rebalancingSetToken and Core instances
        IRebalancingSetToken rebalancingSetToken = IRebalancingSetToken(_rebalancingSetToken);

        // Make sure the rebalancingSetToken is tracked by Core
        require(
            coreInstance.validSets(_rebalancingSetToken),
            "RebalanceAuctionModule.bid: Invalid or disabled SetToken address"
        );

        // Get amount of tokens to transfer to instantiate arrays
        uint256 totalComponents = rebalancingSetToken.getCombinedTokenArrayLength();

        // Instantiate arrays
        address[] memory tokenArray = new address[](totalComponents);
        uint256[] memory inflowUnitArray = new uint256[](totalComponents);
        uint256[] memory outflowUnitArray = new uint256[](totalComponents);

        // Receive addresses of tokens involved and arrays of inflow/outflow associated with each token
        (tokenArray, inflowUnitArray, outflowUnitArray) = rebalancingSetToken.placeBid(_quantity);

        // Retrieve tokens from bidder and deposit in vault for rebalancing set token
        coreInstance.batchDepositModule(
            msg.sender,
            _rebalancingSetToken,
            tokenArray,
            inflowUnitArray
        );

        // Transfer ownership of tokens in vault from rebalancing set token to bidder
        vaultInstance.batchTransferBalance(
            tokenArray,
            _rebalancingSetToken,
            msg.sender,
            outflowUnitArray
        );

        // Log bid placed event
        emit BidPlaced(
            msg.sender,
            _quantity
        );
    }

    /**
     * If a Rebalancing Set Token Rebalance has failed (it includes paused token or exceeds gas limits)
     * and been put in Drawdown state, user's can withdraw their portion of the components collateralizing
     * the Rebalancing Set Token. This burns the user's portion of the Rebalancing Set Token.
     *
     * @param  _rebalancingSetToken    Address of the rebalancing token to withdraw from
     */
    function withdrawFromFailedRebalance(
        address _rebalancingSetToken
    )
        external
        nonReentrant
    {
        // Create Rebalancing Set Token instance
        IRebalancingSetToken rebalancingSetToken = IRebalancingSetToken(_rebalancingSetToken);

        // Make sure the rebalancingSetToken is tracked by Core
        require(
            coreInstance.validSets(_rebalancingSetToken),
            "RebalanceAuctionModule.bid: Invalid or disabled SetToken address"
        );

        // Get combinedTokenArray from RebalancingSetToken
        address[] memory combinedTokenArray = rebalancingSetToken.getCombinedTokenArray();

        // Get Rebalancing Set Token's total supply
        uint256 setTotalSupply = rebalancingSetToken.totalSupply();

        // Get caller's balance
        uint256 callerBalance = rebalancingSetToken.balanceOf(msg.sender);

        // Get RebalancingSetToken component amounts and calculate caller's portion of each token
        uint256 transferArrayLength = combinedTokenArray.length;
        uint256[] memory componentTransferAmount = new uint256[](transferArrayLength);
        for (uint256 i = 0; i < transferArrayLength; i++) {
            uint256 tokenCollateralAmount = vaultInstance.getOwnerBalance(
                combinedTokenArray[i],
                _rebalancingSetToken
            );
            componentTransferAmount[i] = tokenCollateralAmount.mul(callerBalance).div(setTotalSupply);
        }

        // Burn caller's balance of Rebalancing Set Token
        rebalancingSetToken.burn(
            msg.sender,
            callerBalance
        );
        
        // Transfer token amounts to caller in Vault from Rebalancing Set Token
        vaultInstance.batchTransferBalance(
            combinedTokenArray,
            _rebalancingSetToken,
            msg.sender,
            componentTransferAmount
        );
    }
}

// File: ../sc_datasets/DAppSCAN/Trail_of_Bits-setprotocol/set-protocol-contracts-d7ab276464b2cff163db55a9d4c5408e80e5594a/contracts/mocks/core/modules/RebalanceAuctionModuleMock.sol

pragma solidity 0.4.25;


contract RebalanceAuctionModuleMock is 
	RebalanceAuctionModule
{
    constructor(
        address _core,
        address _vault
    )
        public
        RebalanceAuctionModule(_core, _vault)
    {}

	function placeBid(
        address _set,
        uint256 _quantity
    )
        external
    {
        IRebalancingSetToken rebalancingSetToken = IRebalancingSetToken(_set);

        // Issue set token
        rebalancingSetToken.placeBid(
            _quantity
        );
    }
}
