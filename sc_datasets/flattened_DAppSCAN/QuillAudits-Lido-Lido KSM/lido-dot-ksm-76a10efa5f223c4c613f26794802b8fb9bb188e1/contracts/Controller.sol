// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/IRelayEncoder.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/// @author The Moonbeam Team
/// @title The interface through which solidity contracts will interact with Relay Encoder
/// We follow this same interface including four-byte function selectors, in the precompile that
/// wraps the pallet
interface IRelayEncoder {
    // dev Encode 'bond' relay call
    // Selector: 31627376
    // @param controller_address: Address of the controller
    // @param amount: The amount to bond
    // @param reward_destination: the account that should receive the reward
    // @returns The bytes associated with the encoded call
    function encode_bond(uint256 controller_address, uint256 amount, bytes memory reward_destination) external pure returns (bytes memory result);

    // dev Encode 'bond_extra' relay call
    // Selector: 49def326
    // @param amount: The extra amount to bond
    // @returns The bytes associated with the encoded call
    function encode_bond_extra(uint256 amount) external pure returns (bytes memory result);

    // dev Encode 'unbond' relay call
    // Selector: bc4b2187
    // @param amount: The amount to unbond
    // @returns The bytes associated with the encoded call
    function encode_unbond(uint256 amount) external pure returns (bytes memory result);

    // dev Encode 'withdraw_unbonded' relay call
    // Selector: 2d220331
    // @param slashes: Weight hint, number of slashing spans
    // @returns The bytes associated with the encoded call
    function encode_withdraw_unbonded(uint32 slashes) external pure returns (bytes memory result);

    // dev Encode 'validate' relay call
    // Selector: 3a0d803a
    // @param comission: Comission of the validator as parts_per_billion
    // @param blocked: Whether or not the validator is accepting more nominations
    // @returns The bytes associated with the encoded call
    // selector: 3a0d803a
    function encode_validate(uint256 comission, bool blocked) external pure returns (bytes memory result);

    // dev Encode 'nominate' relay call
    // Selector: a7cb124b
    // @param nominees: An array of AccountIds corresponding to the accounts we will nominate
    // @param blocked: Whether or not the validator is accepting more nominations
    // @returns The bytes associated with the encoded call
    function encode_nominate(uint256 [] memory nominees) external pure returns (bytes memory result);

    // dev Encode 'chill' relay call
    // Selector: bc4b2187
    // @returns The bytes associated with the encoded call
    function encode_chill() external pure returns (bytes memory result);

    // dev Encode 'set_payee' relay call
    // Selector: 9801b147
    // @param reward_destination: the account that should receive the reward
    // @returns The bytes associated with the encoded call
    function encode_set_payee(bytes memory reward_destination) external pure returns (bytes memory result);

    // dev Encode 'set_controller' relay call
    // Selector: 7a8f48c2
    // @param controller: The controller address
    // @returns The bytes associated with the encoded call
    function encode_set_controller(uint256 controller) external pure returns (bytes memory result);

    // dev Encode 'rebond' relay call
    // Selector: add6b3bf
    // @param amount: The amount to rebond
    // @returns The bytes associated with the encoded call
    function encode_rebond(uint256 amount) external pure returns (bytes memory result);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/IxTokens.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title Xtokens Interface
 *
 * The interface through which solidity contracts will interact with xtokens pallet
 *
 */
interface IxTokens {
    // A multilocation is defined by its number of parents and the encoded junctions (interior)
    struct Multilocation {
        uint8 parents;
        bytes [] interior;
    }

    /** Transfer a token through XCM based on its currencyId
     *
     * @dev The token transfer burns/transfers the corresponding amount before sending
     * @param currency_address The ERC20 address of the currency we want to transfer
     * @param amount The amount of tokens we want to transfer
     * @param destination The Multilocation to which we want to send the tokens
     * @param weight The weight we want to buy in the destination chain
     */
    function transfer(address currency_address, uint256 amount, Multilocation memory destination, uint64 weight) external;

    /** Transfer a token through XCM based on its currencyId
     *
     * @dev The token transfer burns/transfers the corresponding amount before sending
     * @param asset The asset we want to transfer, defined by its multilocation. Currently only Concrete Fungible assets
     * @param amount The amount of tokens we want to transfer
     * @param destination The Multilocation to which we want to send the tokens
     * @param weight The weight we want to buy in the destination chain
     */
    function transfer_multiasset(Multilocation memory asset, uint256 amount, Multilocation memory destination, uint64 weight) external;
}

// Function selector reference
// {
// "b9f813ff": "transfer(address,uint256,(uint8,bytes[]),uint64)",
// "b38c60fa": "transfer_multiasset((uint8,bytes[]),uint256,(uint8,bytes[]),uint64)"
//}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/IXcmTransactor.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

/**
 * @title Xcm Transactor Interface
 *
 * The interface through which solidity contracts will interact with xcm transactor pallet
 *
 */
interface IXcmTransactor {
    // A multilocation is defined by its number of parents and the encoded junctions (interior)
    struct Multilocation {
        uint8 parents;
        bytes [] interior;
    }

    /** Get index of an account in xcm transactor
     *
     * @param index The index of which we want to retrieve the account
     */
    function index_to_account(uint16 index) external view returns(address);

    /** Get transact info of a multilocation
     * Selector 71b0edfa
     * @param multilocation The location for which we want to retrieve transact info
     */
    function transact_info(Multilocation memory multilocation)
        external view  returns(uint64, uint256, uint64, uint64, uint256);

    /** Transact through XCM using fee based on its multilocation
     *
     * @dev The token transfer burns/transfers the corresponding amount before sending
     * @param transactor The transactor to be used
     * @param index The index to be used
     * @param fee_asset The asset in which we want to pay fees.
     * It has to be a reserve of the destination chain
     * @param weight The weight we want to buy in the destination chain
     * @param inner_call The inner call to be executed in the destination chain
     */
    function transact_through_derivative_multilocation(
        uint8 transactor,
        uint16 index,
        Multilocation memory fee_asset,
        uint64 weight,
        bytes memory inner_call
    ) external;

    /** Transact through XCM using fee based on its currency_id
     *
     * @dev The token transfer burns/transfers the corresponding amount before sending
     * @param transactor The transactor to be used
     * @param index The index to be used
     * @param currency_id Address of the currencyId of the asset to be used for fees
     * It has to be a reserve of the destination chain
     * @param weight The weight we want to buy in the destination chain
     * @param inner_call The inner call to be executed in the destination chain
     */
    function transact_through_derivative(
        uint8 transactor,
        uint16 index,
        address currency_id,
        uint64 weight,
        bytes memory inner_call
    ) external;
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/Types.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface Types {
    struct Fee{
        uint16 total;
        uint16 operators;
        uint16 developers;
        uint16 treasury;
    }

    struct Stash {
        bytes32 stashAccount;
        uint64  eraId;
    }

    enum LedgerStatus {
        // bonded but not participate in staking
        Idle,
        // participate as nominator
        Nominator,
        // participate as validator
        Validator,
        // not bonded not participate in staking
        None
    }

    struct UnlockingChunk {
        uint128 balance;
        uint64 era;
    }

    struct OracleData {
        bytes32 stashAccount;
        bytes32 controllerAccount;
        LedgerStatus stakeStatus;
        // active part of stash balance
        uint128 activeBalance;
        // locked for stake stash balance.
        uint128 totalBalance;
        // totalBalance = activeBalance + sum(unlocked.balance)
        UnlockingChunk[] unlocking;
        uint32[] claimedRewards;
        // stash account balance. It includes locked (totalBalance) balance assigned
        // to a controller.
        uint128 stashBalance;
    }

    struct RelaySpec {
        uint64 genesisTimestamp;
        uint64 secondsPerEra;
        uint64 unbondingPeriod;
        uint16 maxValidatorsPerLedger;
        uint128 minNominatorBalance;
    }
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/interfaces/ILedger.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface ILedger {
    function initialize(
        bytes32 stashAccount,
        bytes32 controllerAccount,
        address vKSM,
        address controller,
        uint128 minNominatorBalance
    ) external;

    function pushData(uint64 eraId, Types.OracleData calldata staking) external;

    function nominate(bytes32[] calldata validators) external;

    function status() external view returns (Types.LedgerStatus);

    function isEmpty() external view returns (bool);

    function stashAccount() external view returns (bytes32);

    function totalBalance() external view returns (uint128);
}

// File: ../sc_datasets/DAppSCAN/QuillAudits-Lido-Lido KSM/lido-dot-ksm-76a10efa5f223c4c613f26794802b8fb9bb188e1/contracts/Controller.sol

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;




contract Controller {
    // ledger controller account
    uint16 public rootDerivativeIndex;

    // relay side account id
    bytes32 public relayAccount;

    // vKSM precompile
    IERC20 internal vKSM;

    // relay call builder precompile
    IRelayEncoder internal relayEncoder;

    // xcm transactor precompile
    IXcmTransactor internal xcmTransactor;

    // xTokens precompile
    IxTokens internal xTokens;

    // Second layer derivative-proxy account to index
    mapping(address => uint16) public senderToIndex;
    mapping(uint16 => bytes32) public indexToAccount;

    uint16 public tododelete;

    enum WEIGHT {
        AS_DERIVATIVE,              // 410_000_000
        BOND_BASE,                  // 600_000_000
        BOND_EXTRA_BASE,            // 1_100_000_000
        UNBOND_BASE,                // 1_250_000_000
        WITHDRAW_UNBONDED_BASE,     // 500_000_000
        WITHDRAW_UNBONDED_PER_UNIT, // 60_000
        REBOND_BASE,                // 1_200_000_000
        REBOND_PER_UNIT,            // 40_000
        CHILL_BASE,                 // 900_000_000
        NOMINATE_BASE,              // 1_000_000_000
        NOMINATE_PER_UNIT,          // 31_000_000
        TRANSFER_TO_PARA_BASE,      // 700_000_000
        TRANSFER_TO_RELAY_BASE      // 4_000_000_000
    }

    uint64 public MAX_WEIGHT;// = 1_835_300_000;

    uint64[] public weights;

    event WeightUpdated (
        uint8 index,
        uint64 newValue
    );

    event Bond (
        address caller,
        bytes32 stash,
        bytes32 controller,
        uint256 amount
    );

    event BondExtra (
        address caller,
        bytes32 stash,
        uint256 amount
    );

    event Unbond (
        address caller,
        bytes32 stash,
        uint256 amount
    );

    event Rebond (
        address caller,
        bytes32 stash,
        uint256 amount
    );

    event Withdraw (
        address caller,
        bytes32 stash
    );

    event Nominate (
        address caller,
        bytes32 stash,
        bytes32[] validators
    );

    event Chill (
        address caller,
        bytes32 stash
    );

    event TransferToRelaychain (
        address from,
        bytes32 to,
        uint256 amount
    );

    event TransferToParachain (
        bytes32 from,
        address to,
        uint256 amount
    );


    modifier onlyRegistred() {
        require(senderToIndex[msg.sender] != 0, "sender isn't registred");
        _;
    }

    function initialize() external {} //stub

    /**
    * @notice Initialize ledger contract.
    * @param _rootDerivativeIndex - stash account id
    * @param _relayAccount - controller account id
    * @param _vKSM - vKSM contract address
    * @param _relayEncoder - relayEncoder(relaychain calls builder) contract address
    * @param _xcmTransactor - xcmTransactor(relaychain calls relayer) contract address
    * @param _xTokens - minimal allowed nominator balance
    */
    function init(
        uint16 _rootDerivativeIndex,
        bytes32 _relayAccount,
        address _vKSM,
        address _relayEncoder,
        address _xcmTransactor,
        address _xTokens
    ) external {
        relayAccount = _relayAccount;
        rootDerivativeIndex = _rootDerivativeIndex;

        vKSM = IERC20(_vKSM);
        relayEncoder = IRelayEncoder(_relayEncoder);
        xcmTransactor = IXcmTransactor(_xcmTransactor);
        xTokens = IxTokens(_xTokens);
    }


    function getWeight(WEIGHT weightType) public returns(uint64) {
        return weights[uint256(weightType)];
    }


    function setMaxWeight(uint64 maxWeight) external {
        MAX_WEIGHT = maxWeight;
    }

    function setWeights(
        uint128[] calldata _weights
    ) external {
        require(_weights.length == uint256(type(WEIGHT).max) + 1, "wrong weights size");
        for (uint256 i = 0; i < _weights.length; ++i) {
            if ((_weights[i] >> 64) > 0) {
                if (weights.length == i) {
                    weights.push(0);
                }

                weights[i] = uint64(_weights[i]);
                emit WeightUpdated(uint8(i), weights[i]);
            }
        }
    }


    function newSubAccount(uint16 index, bytes32 accountId, address paraAddress) external {
        require(indexToAccount[index + 1] == bytes32(0), "already registred");

        senderToIndex[paraAddress] = index + 1;
        indexToAccount[index + 1] = accountId;
    }


    function nominate(bytes32[] calldata validators) external onlyRegistred {
        uint256[] memory convertedValidators = new uint256[](validators.length);
        for (uint256 i = 0; i < validators.length; ++i) {
            convertedValidators[i] = uint256(validators[i]);
        }
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.NOMINATE_BASE) + getWeight(WEIGHT.NOMINATE_PER_UNIT) * uint64(validators.length),
            relayEncoder.encode_nominate(convertedValidators)
        );

        emit Nominate(msg.sender, getSenderAccount(), validators);
    }

    function bond(bytes32 controller, uint256 amount) external onlyRegistred {
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.BOND_BASE),
            relayEncoder.encode_bond(uint256(controller), amount, bytes(hex"00"))
        );

        emit Bond(msg.sender, getSenderAccount(), controller, amount);
    }

    function bondExtra(uint256 amount) external onlyRegistred {
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.BOND_EXTRA_BASE),
            relayEncoder.encode_bond_extra(amount)
        );

        emit BondExtra(msg.sender, getSenderAccount(), amount);
    }

    function unbond(uint256 amount) external onlyRegistred {
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.UNBOND_BASE),
            relayEncoder.encode_unbond(amount)
        );

        emit Unbond(msg.sender, getSenderAccount(), amount);
    }

    function withdrawUnbonded() external onlyRegistred {
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.WITHDRAW_UNBONDED_BASE) + getWeight(WEIGHT.WITHDRAW_UNBONDED_PER_UNIT) * 10,
            relayEncoder.encode_withdraw_unbonded(10/* TODO fix*/)
        );

        emit Withdraw(msg.sender, getSenderAccount());
    }

    function rebond(uint256 amount) external onlyRegistred {
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.REBOND_BASE) + getWeight(WEIGHT.REBOND_PER_UNIT) * 10 /*TODO fix*/,
            relayEncoder.encode_rebond(amount)
        );

        emit Rebond(msg.sender, getSenderAccount(), amount);
    }

    function chill() external onlyRegistred {
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.CHILL_BASE),
            relayEncoder.encode_chill()
        );

        emit Chill(msg.sender, getSenderAccount());
    }

    function transferToParachain(uint256 amount) external onlyRegistred {
        // to - msg.sender, from - getSenderIndex()
        callThroughDerivative(
            getSenderIndex(),
            getWeight(WEIGHT.TRANSFER_TO_PARA_BASE),
            encodeReverseTransfer(msg.sender, amount)
        );

        emit TransferToParachain(getSenderAccount(), msg.sender, amount);
    }

    function transferToRelaychain(uint256 amount) external onlyRegistred {
        // to - getSenderIndex(), from - msg.sender
        vKSM.transferFrom(msg.sender, address(this), amount);
        IxTokens.Multilocation memory destination;
        destination.parents = 1;
        destination.interior = new bytes[](1);
        destination.interior[0] = bytes.concat(bytes1(hex"01"), getSenderAccount(), bytes1(hex"00")); // X2, NetworkId: Any
        xTokens.transfer(address(vKSM), amount + 18900000000, destination, getWeight(WEIGHT.TRANSFER_TO_RELAY_BASE));

        emit TransferToRelaychain(msg.sender, getSenderAccount(), amount);
    }


    function getSenderIndex() internal returns(uint16) {
        return senderToIndex[msg.sender] - 1;
    }

    function getSenderAccount() internal returns(bytes32) {
        return indexToAccount[senderToIndex[msg.sender]];
    }

    function callThroughDerivative(uint16 index, uint64 weight, bytes memory call) internal {
        bytes memory le_index = new bytes(2);
        le_index[0] = bytes1(uint8(index));
        le_index[1] = bytes1(uint8(index >> 8));

        uint64 total_weight = weight + getWeight(WEIGHT.AS_DERIVATIVE);
        require(total_weight <= MAX_WEIGHT, "too much weight");

        xcmTransactor.transact_through_derivative(0, rootDerivativeIndex, address(vKSM),
            total_weight,
            bytes.concat(hex"1001", le_index, call)
        );
    }

    function encodeReverseTransfer(address to, uint256 amount) internal returns(bytes memory) {
        return bytes.concat(
            hex"630201000100a10f0100010300",
            abi.encodePacked(to),
            hex"010400000000",
            scaleCompactUint(amount),
            hex"00000000"
        );
    }

    function toLeBytes(uint256 value, uint256 len) internal returns(bytes memory) {
        bytes memory out = new bytes(len);
        for (uint256 idx = 0; idx < len; ++idx) {
            out[idx] = bytes1(uint8(value));
            value = value >> 8;
        }
        return out;
    }

    function scaleCompactUint(uint256 value) internal returns(bytes memory) {
        if (value < 1<<6) {
            return toLeBytes(value << 2, 1);
        }
        else if(value < 1 << 14) {
            return toLeBytes((value << 2) + 1, 2);
        }
        else if(value < 1 << 30) {
            return toLeBytes((value << 2) + 2, 4);
        }
        else {
            uint256 numBytes = 0;
            {
                uint256 m = value;
                for (; numBytes < 256 && m != 0; ++numBytes) {
                    m = m >> 8;
                }
            }

            bytes memory out = new bytes(numBytes + 1);
            out[0] = bytes1(uint8(((numBytes - 4) << 2) + 3));
            for (uint256 i = 0; i < numBytes; ++i) {
                out[i + 1] = bytes1(uint8(value & 0xFF));
                value = value >> 8;
            }
            return out;
        }
    }
}
